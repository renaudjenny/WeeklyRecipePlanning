import Combine
import ComposableArchitecture
import XCTest

class TestsAppCore: XCTestCase {
    let mainQueue = DispatchQueue.test

    func testUpdateRecipesListWillUpdateWeekRecipes() throws {
        let recipes = IdentifiedArrayOf([Recipe].test.map(RecipeState.init(recipe:)))
        let saveSubject = PassthroughSubject<Bool, ApiError>()
        let store = TestStore(
            initialState: AppState(
                recipeList: RecipeListState(
                    recipes: recipes,
                    selection: Identified(recipes.first!, id: \.id)
                ),
                week: WeekState(recipes: .test, mealTimeRecipes: .test)
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: mainQueue.eraseToAnyScheduler(),
                loadRecipes: .mock(value: .test),
                saveRecipes: { _ in saveSubject.eraseToEffect() },
                uuid: { .zero }
            )
        )

        let newFirstRecipeName = "This new name should be dispatched"
        store.assert(
            .send(.recipeList(.recipe(.nameChanged(newFirstRecipeName)))) {
                // This shall be changed in recipeList.
                $0.recipeList.recipes[id: recipes.first!.id]!.recipe.name = newFirstRecipeName
                $0.recipeList.selection!.recipe.name = newFirstRecipeName

                // And also be changed in Week
                $0.week.recipes[0].name = newFirstRecipeName
            },
            .do { self.mainQueue.advance(by: .seconds(1)) },
            .receive(.recipeList(.save)),
            .do { saveSubject.send(true) },
            .receive(.recipeList(.saved(.success(true))))
        )
    }
}
