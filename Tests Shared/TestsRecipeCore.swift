import Combine
import XCTest
import ComposableArchitecture

@testable import Mes_Superbes_Recettes

class TestsRecipeCore: XCTestCase {
    let recipe = IdentifiedArrayOf<Recipe>.embedded.first!
    var store: TestStore<Recipe, Recipe, RecipeAction, RecipeAction, RecipeEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: recipe,
            reducer: recipeReducer,
            environment: RecipeEnvironment(
                uuid: { .zero }
            )
        )
    }

    func testChangeName() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.nameChanged("Modified by the Test")) {
                $0.name = "Modified by the Test"
            }
        )
    }

    func testChangeMealCount() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.mealCountChanged(5)) {
                $0.mealCount = 5
            }
        )
    }

    func testTapAddIngredientButton() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.addIngredientButtonTapped) {
                $0.ingredients = [.new(id: .zero)] + $0.ingredients
            }
        )
    }

    func testRemoveIngredient() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.ingredientsDeleted(IndexSet(integer: 0))) {
                $0.ingredients = IdentifiedArrayOf($0.ingredients.dropFirst())
            }
        )
    }

    func testChangeIngredientName() throws {
        let store = try XCTUnwrap(self.store)
        let firstIngredientId = try XCTUnwrap(recipe.ingredients.first?.id)

        store.assert(
            .send(.ingredient(id: firstIngredientId, action: .nameChanged("Test ingredient Name"))) {
                $0.ingredients[0].name = "Test ingredient Name"
            }
        )
    }

    func testChangeIngredientQuantityWithValidOne() throws {
        let store = try XCTUnwrap(self.store)
        let firstIngredientId = try XCTUnwrap(recipe.ingredients.first?.id)

        store.assert(
            .send(.ingredient(id: firstIngredientId, action: .quantityChanged("10"))) {
                $0.ingredients[0].quantity = 10
            }
        )
    }

    func testChangeIngredientQuantityWithInvalidOne() throws {
        let store = try XCTUnwrap(self.store)
        let firstIngredientId = try XCTUnwrap(recipe.ingredients.first?.id)

        store.assert(
            .send(.ingredient(id: firstIngredientId, action: .quantityChanged("abcd"))) {
                $0.ingredients[0].quantity = $0.ingredients[0].quantity
            },
            .receive(.ingredient(id: firstIngredientId, action: .quantityFormatError))
        )
    }
}
