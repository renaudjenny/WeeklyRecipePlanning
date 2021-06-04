import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsWeekCore: XCTestCase {
    var store: TestStore<WeekState, WeekState, WeekAction, WeekAction, WeekEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: WeekState(recipes: .test, mealTimeRecipes: .test),
            reducer: weekReducer,
            environment: WeekEnvironment()
        )
    }

    func testSetRecipeForAMealTime() throws {
        let store = try XCTUnwrap(self.store)
        let recipe = [Recipe].test[2]

        store.assert(
            .send(.mealTime(id: .sundayDinner, action: .mealTimeTapped)) {
                $0.mealTimes[id: .sundayDinner]?.recipeSelector = RecipeSelectorState(
                    mealTime: .sundayDinner,
                    recipes: .test,
                    mealTimeRecipes: .test
                )
            },
            .send(.mealTime(id: .sundayDinner, action: .recipeSelector(.setRecipe(recipe)))) { state in
                state.mealTimeRecipes[.sundayDinner] = recipe
                state.mealTimeRecipes[.mondayLunch] = Recipe?.none

                state.mealTimes = IdentifiedArrayOf(MealTime.allCases.map { mealTime in
                    MealTimeState(
                        mealTime: mealTime,
                        recipes: .test,
                        mealTimeRecipes: state.mealTimeRecipes
                    )
                })
            }
        )
    }
}
