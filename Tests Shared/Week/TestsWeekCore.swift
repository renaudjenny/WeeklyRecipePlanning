import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsWeekCore: XCTestCase {
    var store: TestStore<WeekState, WeekState, WeekAction, WeekAction, WeekEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: WeekState(allRecipes: .test, recipes: .test),
            reducer: weekReducer,
            environment: WeekEnvironment()
        )
    }

    func testMealTimeFilledCount() throws {
        let state = WeekState(allRecipes: .test, recipes: .test)
        // Count the meal you can serve for the week with accumulating meal count of recipes
        XCTAssertEqual(state.mealTimeFilledCount, 8)
    }

    func testMealTimes() throws {
        let state = WeekState(allRecipes: .test, recipes: .test)
        let firstRecipeWith2Meals = [Recipe].test[0]
        let secondRecipeWith2Meals = [Recipe].test[1]
        let thirdRecipeWith1Meal = [Recipe].test[2]
        let fourthRecipeWith1Meal = [Recipe].test[3]
        let fifthRecipeWith1Meal = [Recipe].test[4]
        let sixthRecipeWith1Meal = [Recipe].test[5]
        let expectedMealTimeRecipe = [
            MealTimeRecipe(mealTime: .sundayDinner, recipe: firstRecipeWith2Meals),
            MealTimeRecipe(mealTime: .mondayLunch, recipe: firstRecipeWith2Meals),
            MealTimeRecipe(mealTime: .mondayDinner, recipe: secondRecipeWith2Meals),
            MealTimeRecipe(mealTime: .tuesdayLunch, recipe: secondRecipeWith2Meals),
            MealTimeRecipe(mealTime: .tuesdayDinner, recipe: thirdRecipeWith1Meal),
            MealTimeRecipe(mealTime: .wednesdayLunch, recipe: fourthRecipeWith1Meal),
            MealTimeRecipe(mealTime: .wednesdayDinner, recipe: fifthRecipeWith1Meal),
            MealTimeRecipe(mealTime: .thursdayLunch, recipe: sixthRecipeWith1Meal),
            MealTimeRecipe(mealTime: .thursdayDinner, recipe: nil),
            MealTimeRecipe(mealTime: .fridayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .fridayDinner, recipe: nil),
            MealTimeRecipe(mealTime: .saturdayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .saturdayDinner, recipe: nil),
            MealTimeRecipe(mealTime: .sundayLunch, recipe: nil),
        ]

        XCTAssertEqual(state.mealTimes, expectedMealTimeRecipe)
    }

    func testDisplayedRecipes() throws {
        // Test Recipes are named Recipe X where X is in this order:
        // A, B, C, D, F, E.
        // Note that F and E, so we're suppose to see the sixth Recipe before the fifth.
        let firstRecipe = [Recipe].test[0]
        let secondRecipe = [Recipe].test[1]
        let thirdRecipe = [Recipe].test[2]
        let fourthRecipe = [Recipe].test[3]
        let fifthRecipe = [Recipe].test[4]
        let sixthRecipe = [Recipe].test[5]
        var state = WeekState(allRecipes: .test, recipes: [thirdRecipe, secondRecipe], isRecipeListPresented: true)
        // Recipes should be in alphabetic order and ones in week shall be in last positions
        XCTAssertEqual(state.displayedRecipes, [
            firstRecipe,
            fourthRecipe,
            sixthRecipe,
            fifthRecipe,
            secondRecipe,
            thirdRecipe,
        ])

        state.isRecipeListPresented = false
        XCTAssertEqual(state.displayedRecipes, [thirdRecipe, secondRecipe])
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
                $0.recipes = $0.recipes + [recipeToAdd]
            }
        )
    }

    func testRemoveRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let recipeToRemove = try XCTUnwrap([Recipe].test.first)

        store.assert(
            .send(.removeRecipe(recipeToRemove)) {
                $0.recipes = Array([Recipe].test.dropFirst())
            }
        )
    }
}
