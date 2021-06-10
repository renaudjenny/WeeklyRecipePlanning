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

    func testChangeIngredientListUpdateRecipeIngredients() throws {
        let store = try XCTUnwrap(self.store)
        let firstIngredientId = try XCTUnwrap(self.recipe.ingredients.first?.id)
        let newIngredientName = "New Ingredient Name"

        store.assert(
            .send(.ingredientList(.ingredient(
                id: firstIngredientId,
                action: .nameChanged(newIngredientName)
            ))) {
                $0.ingredients[0].name = newIngredientName
                $0.ingredientList
                    .ingredients[id: firstIngredientId]?
                    .ingredient
                    .name = newIngredientName
            }
        )
    }
}
