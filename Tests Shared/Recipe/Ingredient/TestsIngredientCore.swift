import Combine
import XCTest
import ComposableArchitecture

@testable import Mes_Superbes_Recettes

class TestsIngredientCore: XCTestCase {
    let ingredient = [Recipe].embedded.first!.ingredients.first!
    var store: TestStore<IngredientState, IngredientState, IngredientAction, IngredientAction, IngredientEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: IngredientState(ingredient: ingredient),
            reducer: ingredientReducer,
            environment: IngredientEnvironment()
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

    func testChangeQuantityWithValidOne() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.quantityChanged("10")) {
                $0.quantity = 10
            }
        )
    }

    func testChangeIngredientQuantityWithInvalidOne() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.quantityChanged("abcd")) {
                $0.quantity = $0.quantity
            },
            .receive(.quantityFormatError)
        )
    }

    func testChangeUnit() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.unitChanged(UnitMass.kilograms)) {
                $0.unit = UnitMass.kilograms
            }
        )
    }

    func testTapOnEditIngredientUnit() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.unitButtonTapped) {
                $0.isUnitInEditionMode = true
            },
            .send(.unitButtonTapped) {
                $0.isUnitInEditionMode = false
            }
        )
    }
}
