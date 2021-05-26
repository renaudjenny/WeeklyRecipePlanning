import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsRecipeSelectorCore: XCTestCase {
    var store: TestStore<RecipeSelectorState, RecipeSelectorState, RecipeSelectorAction, RecipeSelectorAction, RecipeSelectorEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: RecipeSelectorState(
                mealTime: .sundayDinner,
                recipes: .test,
                mealTimeRecipes: .test
            ),
            reducer: recipeSelectorReducer,
            environment: RecipeSelectorEnvironment()
        )
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
        let state = RecipeSelectorState(
            mealTime: .sundayLunch,
            recipes: .test,
            mealTimeRecipes: .init(uniqueKeysWithValues: MealTime.allCases.map {
                switch $0 {
                case .mondayDinner: return ($0, secondRecipe)
                case .tuesdayLunch: return ($0, secondRecipe)
                case .wednesdayDinner: return ($0, thirdRecipe)
                default: return ($0, nil)
                }
            })
        )

        // Recipes should be in alphabetic order and ones in week shall be in last positions
        // A, D, E, F, B, C
        XCTAssertEqual(state.recipesToDisplay, [
            firstRecipe,
            fourthRecipe,
            sixthRecipe,
            fifthRecipe,
            secondRecipe,
            thirdRecipe,
        ])
    }

    func testSetRecipe() throws {
        let store = try XCTUnwrap(self.store)
        let recipe = Recipe(
            id: UUID(),
            name: "Test Recipe",
            mealCount: 2,
            ingredients: []
        )

        store.assert(
            .send(.setRecipe(recipe)) {
                var expectedMealTimeRecipes = [MealTime: Recipe?].test
                expectedMealTimeRecipes[.sundayDinner] = recipe
                expectedMealTimeRecipes[.mondayLunch] = recipe

                $0.mealTimeRecipes = expectedMealTimeRecipes
            }
        )
    }

    func testSetRecipeForSundayWithOverlappingUntilTuesday() throws {
        let store = TestStore(
            initialState: RecipeSelectorState(mealTime: .sundayLunch, recipes: .test, mealTimeRecipes: .test),
            reducer: recipeSelectorReducer,
            environment: RecipeSelectorEnvironment()
        )
        let recipe = Recipe(
            id: UUID(),
            name: "Mega Paella",
            mealCount: 4,
            ingredients: []
        )

        store.assert(
            .send(.setRecipe(recipe)) {
                var expectedMealTimeRecipes = [MealTime: Recipe?].test
                expectedMealTimeRecipes[.sundayLunch] = recipe
                expectedMealTimeRecipes[.sundayDinner] = recipe
                expectedMealTimeRecipes[.mondayLunch] = recipe
                expectedMealTimeRecipes[.mondayDinner] = recipe

                $0.mealTimeRecipes = expectedMealTimeRecipes
            }
        )
    }

    func testSetRecipeThatOverridesAnotherRecipeButTheNewOneHasLessMealCount() throws {
        let store = try XCTUnwrap(self.store)
        let recipe = Recipe(
            id: UUID(),
            name: "Small recipe",
            mealCount: 1,
            ingredients: []
        )

        store.assert(
            .send(.setRecipe(recipe)) {
                var expectedMealTimeRecipes = [MealTime: Recipe?].test
                expectedMealTimeRecipes[.sundayDinner] = recipe
                expectedMealTimeRecipes[.mondayLunch] = Recipe?.none

                $0.mealTimeRecipes = expectedMealTimeRecipes
            }
        )
    }

    func testRemoveRecipe() throws {
        let store = try XCTUnwrap(self.store)

        store.assert(
            .send(.removeRecipe) {
                var expectedMealTimeRecipes = [MealTime: Recipe?].test
                expectedMealTimeRecipes[.sundayDinner] = Recipe?.none
                expectedMealTimeRecipes[.mondayLunch] = Recipe?.none

                $0.mealTimeRecipes = expectedMealTimeRecipes
            }
        )
    }
}
