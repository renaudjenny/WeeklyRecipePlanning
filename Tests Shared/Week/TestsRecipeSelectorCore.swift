import Combine
import XCTest
import ComposableArchitecture

@testable import WeeklyRecipePlanning

class TestsRecipeSelectorCore: XCTestCase {
    var store: TestStore<RecipeSelectorState, RecipeSelectorState, RecipeSelectorAction, RecipeSelectorAction, RecipeSelectorEnvironment>?

    override func setUp() {
        store = TestStore(
            initialState: RecipeSelectorState(mealTime: .sundayDinner, recipes: .test, mealTimeRecipes: .test),
            reducer: recipeSelectorReducer,
            environment: RecipeSelectorEnvironment()
        )
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
