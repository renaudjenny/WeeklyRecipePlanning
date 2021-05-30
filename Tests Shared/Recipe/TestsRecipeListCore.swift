import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsRecipeListCore: XCTestCase {
    let recipes = [Recipe].test
    let mainQueue = DispatchQueue.test
    var loadSubject: PassthroughSubject<[Recipe], ApiError>?
    var saveSubject: PassthroughSubject<Bool, ApiError>?
    var store: TestStore<RecipeListState, RecipeListState, RecipeListAction, RecipeListAction, RecipeListEnvironment>?

    override func setUp() {
        let loadSubject = PassthroughSubject<[Recipe], ApiError>()
        let saveSubject = PassthroughSubject<Bool, ApiError>()
        store = TestStore(
            initialState: RecipeListState(recipes: IdentifiedArrayOf(recipes.map(RecipeState.init))),
            reducer: recipeListReducer,
            environment: RecipeListEnvironment(
                mainQueue: mainQueue.eraseToAnyScheduler(),
                load: loadSubject.eraseToEffect(),
                save: { _ in saveSubject.eraseToEffect() },
                uuid: { .zero }
            )
        )
        self.loadSubject = loadSubject
        self.saveSubject = saveSubject
    }

    func testUpdateAndSaveRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let saveSubject = try XCTUnwrap(self.saveSubject)

        let recipes = [Recipe].test
        let firstRecipe = try XCTUnwrap(recipes.first)

        store.assert(
            .send(.setNavigation(selection: firstRecipe.id)) {
                $0.selection = Identified(RecipeState(recipe: firstRecipe), id: firstRecipe.id)
            },
            .send(.recipe(RecipeAction.nameChanged("Modified by Test"))) {
                $0.recipes[0].name = "Modified by Test"
            },
            .do { self.mainQueue.advance(by: .seconds(1)) },
            .receive(.save),
            .do { saveSubject.send(true) },
            .receive(.saved(.success(true)))
        )
    }

    func testAddRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let newRecipeState = RecipeState(recipe: .new(id: .zero))

        store.assert(
            .send(.addNewRecipe) {
                $0.recipes = [newRecipeState] + $0.recipes
            },
            .receive(.setNavigation(selection: newRecipeState.id)) {
                $0.selection = Identified(newRecipeState, id: newRecipeState.id)
            }
        )
    }

    func testLoadRecipes() throws {
        let store = try XCTUnwrap(self.store)
        let loadSubject = try XCTUnwrap(self.loadSubject)

        let recipesToLoad = [
            Recipe(id: UUID(), name: "Test 1", mealCount: 1, ingredients: []),
            Recipe(id: UUID(), name: "Test 2", mealCount: 2, ingredients: [])
        ]

        store.assert(
            .send(.load),
            .do { loadSubject.send(recipesToLoad) },
            .receive(.loaded(.success(recipesToLoad))) {
                $0.recipes = IdentifiedArrayOf(recipesToLoad.map(RecipeState.init))
            }
        )
    }

    func testRemoveRecipes() throws {
        let store = try XCTUnwrap(self.store)
        let saveSubject = try XCTUnwrap(self.saveSubject)

        let recipesWithoutLast = IdentifiedArrayOf(
            [Recipe].test
                .dropLast()
                .map(RecipeState.init)
        )

        store.assert(
            .send(.delete(IndexSet(integer: recipesWithoutLast.count))) {
                $0.recipes = recipesWithoutLast
            },
            .receive(.save),
            .do { saveSubject.send(true) },
            .receive(.saved(.success(true)))
        )
    }
}
