import ComposableArchitecture
import SwiftUI

struct RecipeView: View {
    let store: Store<RecipeState, RecipeAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section(header: Text("Title")) {
                    TextField("Name", text: viewStore.binding(get: { $0.name }, send: RecipeAction.nameChanged))
                        .font(.title)
                }

                Stepper("Meal count: \(viewStore.mealCount)", value: viewStore.binding(get: { $0.mealCount }, send: RecipeAction.mealCountChanged), in: 0...99)

                IngredientListView(store: store.scope(state: { $0.ingredientList }, action: RecipeAction.ingredientList))
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(store: Store(
            initialState: RecipeState(recipe: Recipe(
                id: UUID(),
                name: "Preview recipe",
                mealCount: 1,
                ingredients: [
                    Ingredient(id: UUID(), name: "Water", quantity: 100, unit: UnitVolume.centiliters),
                    Ingredient(id: UUID(), name: "Chocolate", quantity: 200, unit: UnitMass.grams),
                ]
            )),
            reducer: recipeReducer,
            environment: RecipeEnvironment(uuid: { UUID() })
        ))
    }
}

extension RecipeView {
    init(readOnlyRecipe recipe: Recipe) {
        self.init(store: Store(
            initialState: RecipeState(recipe: recipe),
            reducer: .empty,
            environment: RecipeEnvironment(uuid: UUID.init)
        ))
    }
}
