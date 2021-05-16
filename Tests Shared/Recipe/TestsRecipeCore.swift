import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsRecipeCore: XCTestCase {
    let recipe = [Recipe].test.first!
    var store: TestStore<RecipeState, RecipeState, RecipeAction, RecipeAction, RecipeEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: RecipeState(recipe: recipe),
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
}
