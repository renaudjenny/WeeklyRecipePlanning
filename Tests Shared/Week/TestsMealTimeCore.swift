import ComposableArchitecture
import XCTest

class TestsMealTimeCore: XCTestCase {
    func testMealTimeTapped() throws {
        let store = TestStore(
            initialState: MealTimeState(
                mealTime: .sundayLunch,
                recipes: .test,
                mealTimeRecipes: .test
            ),
            reducer: mealTimeReducer,
            environment: MealTimeEnvironment()
        )

        store.assert(
            .send(.mealTimeTapped) {
                $0.recipeSelector = RecipeSelectorState(
                    mealTime: $0.mealTime,
                    recipes: $0.recipes,
                    mealTimeRecipes: $0.mealTimeRecipes
                )
            }
        )
    }

    func testDismissRecipeSelector() throws {
        let store = TestStore(
            initialState: MealTimeState(
                mealTime: .sundayLunch,
                recipes: .test,
                mealTimeRecipes: .test,
                recipeSelector: RecipeSelectorState(
                    mealTime: .sundayLunch,
                    recipes: .test,
                    mealTimeRecipes: .test
                )
            ),
            reducer: mealTimeReducer,
            environment: MealTimeEnvironment()
        )

        store.assert(
            .send(.dismissRecipeSelector) {
                $0.recipeSelector = nil
            }
        )
    }

    func testNewMealTimeRecipeFromSelector() throws {
        let store = TestStore(
            initialState: MealTimeState(
                mealTime: .sundayLunch,
                recipes: .test,
                mealTimeRecipes: .test,
                recipeSelector: RecipeSelectorState(
                    mealTime: .sundayLunch,
                    recipes: .test,
                    mealTimeRecipes: .test
                )
            ),
            reducer: mealTimeReducer,
            environment: MealTimeEnvironment()
        )

        let recipe = [Recipe].test[3]
        store.assert(
            .send(.recipeSelector(.setRecipe(recipe))) {
                $0.mealTimeRecipes[.sundayLunch] = recipe
                $0.recipeSelector?.mealTimeRecipes[.sundayLunch] = recipe
            }
        )
    }
}
