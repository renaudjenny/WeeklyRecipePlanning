import Combine
import XCTest
import ComposableArchitecture

@testable import Mes_Superbes_Recettes

class TestsRecipesCore: XCTestCase {
    func testAddRecipe() throws {
        let persistedRecipesSubject = PassthroughSubject<[Recipe], ApiError>()
        let saveRecipesSubject = PassthroughSubject<Bool, ApiError>()

        let store = TestStore(
            initialState: RecipesState(),
            reducer: recipesReducer,
            environment: RecipesEnvironment(
                persistedRecipes: persistedRecipesSubject.eraseToEffect(),
                saveRecipes: { _ in saveRecipesSubject.eraseToEffect() }
            )
        )

        let newRecipe = Recipe(name: "Test", mealCount: 1, ingredients: [])

        store.assert(
            .send(.addRecipe(newRecipe)) {
                $0.recipes = $0.recipes + [newRecipe]
            },
            .receive(.saveRecipes),
            .do { saveRecipesSubject.send(true) },
            .receive(.saved(.success(true)))
        )
    }
}
