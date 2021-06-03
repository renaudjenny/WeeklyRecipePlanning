import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsWeekCore: XCTestCase {
    var store: TestStore<WeekState, WeekState, WeekAction, WeekAction, WeekEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: WeekState(allRecipes: .test, mealTimeRecipes: .test),
            reducer: weekReducer,
            environment: WeekEnvironment()
        )
    }

    func testSelectMealTime() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.selectMealTime(.wednesdayDinner)) {
                $0.selectedMealTime = .wednesdayDinner
            }
        )
    }

    func testDismissMealTime() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.selectMealTime(.sundayLunch)) {
                $0.selectedMealTime = .sundayLunch
            },
            .send(.dismissMealTime) {
                $0.selectedMealTime = nil
            }
        )
    }
}
