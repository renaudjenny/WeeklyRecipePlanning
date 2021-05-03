import Combine
import XCTest
import ComposableArchitecture

@testable import Mes_Superbes_Recettes

class TestsRecipeListCore: XCTestCase {
    let recipes = [Recipe].embedded
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

        let recipes = [Recipe].embedded
        let firstRecipe = try XCTUnwrap(recipes.first)

        store.assert(
            .send(.recipe(id: firstRecipe.id, action: RecipeAction.nameChanged("Modified by Test"))) {
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
        let saveSubject = try XCTUnwrap(self.saveSubject)

        store.assert(
            .send(.addButtonTapped) {
                $0.recipes = [RecipeState(recipe: .new(id: .zero))] + $0.recipes
            },
            .receive(.save),
            .do { saveSubject.send(true) },
            .receive(.saved(.success(true)))
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
            [Recipe].embedded
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
