import Combine
import XCTest
import ComposableArchitecture

@testable import Mes_Superbes_Recettes

class TestsRecipesCore: XCTestCase {
    var loadSubject: PassthroughSubject<IdentifiedArrayOf<Recipe>, ApiError>?
    var saveSubject: PassthroughSubject<Bool, ApiError>?
    var store: TestStore<RecipesState, RecipesState, RecipesAction, RecipesAction, RecipesEnvironment>?

    override func setUp() {
        let loadSubject = PassthroughSubject<IdentifiedArrayOf<Recipe>, ApiError>()
        let saveSubject = PassthroughSubject<Bool, ApiError>()
        store = TestStore(
            initialState: RecipesState(),
            reducer: recipesReducer,
            environment: RecipesEnvironment(
                load: { loadSubject.eraseToEffect() },
                save: { _ in saveSubject.eraseToEffect() }
            )
        )
        self.loadSubject = loadSubject
        self.saveSubject = saveSubject
    }

    func testUpdateRecipe() throws {
        let store = try XCTUnwrap(self.store)

        let recipes = IdentifiedArrayOf<Recipe>.embedded
        let firstRecipe = try XCTUnwrap(recipes.first)

        store.assert(
            .send(.recipe(id: firstRecipe.id, action: RecipeAction.nameChanged("Modified by Test"))) {
                $0.recipes[0].name = "Modified by Test"
            }
        )
    }

    func testAddRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let saveSubject = try XCTUnwrap(self.saveSubject)

        store.assert(
            .send(.addRecipeButtonTapped) {
                $0.recipes = $0.recipes + [Recipe.new]
            },
            .receive(.save),
            .do { saveSubject.send(true) },
            .receive(.saved(.success(true)))
        )
    }

    func testLoadRecipes() throws {
        let store = try XCTUnwrap(self.store)
        let loadSubject = try XCTUnwrap(self.loadSubject)

        let recipesToLoad = IdentifiedArrayOf([
            Recipe(name: "Test 1", mealCount: 1, ingredients: []),
            Recipe(name: "Test 2", mealCount: 2, ingredients: [])
        ])

        store.assert(
            .send(.load),
            .do { loadSubject.send(recipesToLoad) },
            .receive(.loaded(.success(recipesToLoad))) {
                $0.recipes = recipesToLoad
            }
        )
    }
}
