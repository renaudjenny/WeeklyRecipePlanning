import ComposableArchitecture
import SwiftUI

struct RecipeView: View {
    struct ViewState: Equatable {
        var recipe: Recipe
    }
    enum ViewAction: Equatable {
        case updateRecipe(Recipe)
    }

    let recipe: Recipe
    let store: Store<RecipesState, RecipesAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0.view(for: recipe) }, action: RecipesAction.view)) { viewStore in
            VStack {
                TextField("Name", text: viewStore.€recipe.name)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack {
                    Stepper("Meal count", value: viewStore.€recipe.mealCount, in: 0...99)
                    Text("\(viewStore.recipe.mealCount)")
                }
                .padding()

                Divider()

                HStack {
                    Text("Ingredients")
                    Button(action: { addIngredient(to: viewStore.€recipe) }) {
                        Image(systemName: "plus")
                    }
                }
                .padding()

                List {
                    ForEach(viewStore.€recipe.ingredients, content: ingredientRow)
                }
            }
        }
    }

    private func addIngredient(to recipe: Binding<Recipe>) {
        recipe.wrappedValue.ingredients.insert(Ingredient(name: "New ingredient", quantity: 1.25, unit: UnitVolume.centiliters), at: 0)
    }

    private func ingredientRow(index: Int, ingredient: Binding<Ingredient>) -> some View {
        VStack {
            TextField("Name", text: ingredient.name)
                .font(.title2)
            TextField("Quantity", text: ingredient.quantity.text)
            // TODO: Unit
        }
    }
}

extension Binding where Value == Double {
    var text: Binding<String> {
        .init(
            get: { numberFormatterDecimal.string(from: NSNumber(value: self.wrappedValue)) ?? "ERROR" },
            set: { self.wrappedValue = Double($0) ?? 0 }
        )
    }
}

private extension RecipesState {
    func view(for recipe: Recipe) -> RecipeView.ViewState {
        let recipe = recipes.first(where: { $0 == recipe }) ?? .error
        return RecipeView.ViewState(recipe: recipe)
    }
}

private extension RecipesAction {
    static func view(localAction: RecipeView.ViewAction) -> Self {
        switch localAction {
        case let .updateRecipe(recipe): return .update(recipe)
        }
    }
}

private extension ViewStore where State == RecipeView.ViewState, Action == RecipeView.ViewAction {
    var €recipe: Binding<Recipe> {
        binding(get: { $0.recipe }, send: RecipeView.ViewAction.updateRecipe)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(
            recipe: [Recipe].embedded.first!,
            store: Store(
                initialState: RecipesState(),
                reducer: recipesReducer,
                environment: .mock
            )
        )
    }
}
