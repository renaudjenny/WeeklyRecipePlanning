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

    func testMealTimeFilledCount() throws {
        let state = WeekState(allRecipes: .test, mealTimeRecipes: .test)
        // Count the meal you can serve for the week with accumulating meal count of recipes
        XCTAssertEqual(state.mealTimeFilledCount, 8)
    }

    func testMealTimes() throws {
        let state = WeekState(allRecipes: .test, mealTimeRecipes: .test)
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
            MealTimeRecipe(mealTime: .thursdayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .thursdayDinner, recipe: nil),
            MealTimeRecipe(mealTime: .fridayLunch, recipe: nil),
            MealTimeRecipe(mealTime: .fridayDinner, recipe: nil),
            MealTimeRecipe(mealTime: .saturdayLunch, recipe: sixthRecipeWith1Meal),
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
        let state = WeekState(allRecipes: .test, mealTimeRecipes: .init(uniqueKeysWithValues: MealTime.allCases.map {
            switch $0 {
            case .mondayDinner: return ($0, secondRecipe)
            case .tuesdayLunch: return ($0, secondRecipe)
            case .wednesdayDinner: return ($0, thirdRecipe)
            default: return ($0, nil)
            }
        }))
        // Recipes should be in alphabetic order and ones in week shall be in last positions
        XCTAssertEqual(state.displayedRecipes, [
            firstRecipe,
            fourthRecipe,
            sixthRecipe,
            fifthRecipe,
            secondRecipe,
            thirdRecipe,
        ])
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
            .send(.addRecipe(recipeToAdd, .fridayLunch)) {
                var expectedMealTimeRecipes = [MealTime: Recipe?].test
                expectedMealTimeRecipes[.fridayLunch] = recipeToAdd
                expectedMealTimeRecipes[.fridayDinner] = recipeToAdd

                $0.mealTimeRecipes = expectedMealTimeRecipes
            }
        )
    }

    func testRemoveRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let recipeToRemove = try XCTUnwrap([Recipe].test.first)

        store.assert(
            .send(.removeRecipe(recipeToRemove, .sundayDinner)) {
                var expectedMealTimeRecipes = [MealTime: Recipe?].test
                expectedMealTimeRecipes[.sundayDinner] = nil
                expectedMealTimeRecipes[.mondayLunch] = nil

                $0.mealTimeRecipes = expectedMealTimeRecipes
            }
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
