import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsIngredientListCore: XCTestCase {
    let ingredients = [Recipe].embedded.first!.ingredients
    var store: TestStore<IngredientListState, IngredientListState, IngredientListAction, IngredientListAction, IngredientListEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: IngredientListState(ingredients: IdentifiedArrayOf(ingredients.map { IngredientState(ingredient: $0) })),
            reducer: ingredientListReducer,
            environment: IngredientListEnvironment(uuid: { .zero })
        )
    }

    func testChangeFirstIngredientName() throws {
        let store = try XCTUnwrap(self.store)
        let firstIngredientId = try XCTUnwrap(ingredients.first?.id)

        store.assert(
            .send(.ingredient(id: firstIngredientId, action: .nameChanged("Modified by the Test"))) {
                $0.ingredients[0].name = "Modified by the Test"
            }
        )
    }

    func testTapAddIngredient() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.addButtonTapped) {
                $0.ingredients = [IngredientState(ingredient: .new(id: .zero))] + $0.ingredients
            }
        )
    }

    func testRemoveIngredient() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.delete(IndexSet(integer: 0))) {
                $0.ingredients = IdentifiedArrayOf($0.ingredients.dropFirst())
            }
        )
    }
}
