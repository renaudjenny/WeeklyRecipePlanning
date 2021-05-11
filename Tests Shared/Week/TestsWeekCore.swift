import Combine
import XCTest
import ComposableArchitecture

@testable import Mes_Superbes_Recettes

class TestsWeekCore: XCTestCase {
    let week = Week(recipes: [Recipe].embedded)
    var store: TestStore<WeekState, WeekState, WeekAction, WeekAction, WeekEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: WeekState(recipes: .embedded, week: week),
            reducer: weekReducer,
            environment: WeekEnvironment()
        )
    }

    func testMealTimeFilledCount() throws {
        let state = WeekState(recipes: .embedded, week: week)
        // Count the meal you can serve for the week with accumulating meal count of recipes
        XCTAssertEqual(state.mealTimeFilledCount, 5)
    }

    func testMealTimes() throws {
        let state = WeekState(recipes: .embedded, week: week)
        let firstRecipeWith2Meals = [Recipe].embedded[0]
        let secondRecipeWith2Meals = [Recipe].embedded[1]
        let thirdRecipeWith1Meal = [Recipe].embedded[2]
        let expectedMealTimeRecipe = [
            MealTimeRecipe(mealTime: .sundayDiner, recipe: firstRecipeWith2Meals),
            MealTimeRecipe(mealTime: .mondayLunch, recipe: firstRecipeWith2Meals),
            MealTimeRecipe(mealTime: .mondayDiner, recipe: secondRecipeWith2Meals),
            MealTimeRecipe(mealTime: .tuesdayLunch, recipe: secondRecipeWith2Meals),
            MealTimeRecipe(mealTime: .tuesdayDiner, recipe: thirdRecipeWith1Meal),
            MealTimeRecipe(mealTime: .wednesdayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .wednesdayDiner, recipe: nil),
            MealTimeRecipe(mealTime: .thursdayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .thursdayDiner, recipe: nil),
            MealTimeRecipe(mealTime: .fridayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .fridayDiner, recipe: nil),
            MealTimeRecipe(mealTime: .saturdayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .saturdayDiner, recipe: nil),
            MealTimeRecipe(mealTime: .sundayLunch, recipe: nil),
        ]

        XCTAssertEqual(state.mealTimes, expectedMealTimeRecipe)
    }

    func testUnselectedRecipes() throws {
        let state = WeekState(recipes: .embedded, week: week)
        XCTAssertEqual(state.unselectedRecipes, [])

        let weekWithOnlyOneRecipe = Week(recipes: [[Recipe].embedded[0]])
        let anotherState = WeekState(recipes: .embedded, week: weekWithOnlyOneRecipe)
        XCTAssertEqual(anotherState.unselectedRecipes, [[Recipe].embedded[1], [Recipe].embedded[2]])
    }

    func testAddRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let recipeToAdd = Recipe(
            id: UUID(),
            name: "Test Recipe",
            mealCount: 2,
            ingredients: []
        )

        store.assert(
            .send(.addRecipe(recipeToAdd)) {
                $0.week.recipes = $0.week.recipes + [recipeToAdd]
            }
        )
    }

    func testRemoveRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let recipeToRemove = try XCTUnwrap([Recipe].embedded.first)

        store.assert(
            .send(.removeRecipe(recipeToRemove)) {
                $0.week.recipes = Array([Recipe].embedded.dropFirst())
            }
        )
    }
}
