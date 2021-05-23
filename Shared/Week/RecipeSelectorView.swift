import ComposableArchitecture
import SwiftUI

struct RecipeSelectorView: View {
    let store: Store<WeekState, WeekAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Section(header: Text("Number of different recipes: \(viewStore.recipes.count)")) {
                List {
                    ForEach(viewStore.displayedRecipes) { recipe in
                        recipeCell(recipe, viewStore: viewStore)
                    }
                }
            }
        }
    }

    private func recipeCell(_ recipe: Recipe, viewStore: ViewStore<WeekState, WeekAction>) -> some View {
        HStack {
            Text(recipe.name)
                .foregroundColor(viewStore.recipes.contains(recipe) ? .primary : .secondary)
            Spacer()
            Button {
                if let mealTime = viewStore.selectedMealTime {
                    if viewStore.recipes.contains(recipe) {
                        viewStore.send(.removeRecipe(recipe, mealTime), animation: .default)
                    } else {
                        viewStore.send(.addRecipe(recipe, mealTime), animation: .default)
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(
                        viewStore.recipes.contains(recipe)
                            ? Color.red.opacity(0.6)
                            : Color.accentColor
                    )
                    Image(systemName: viewStore.recipes.contains(recipe) ? "minus" : "plus")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 50, height: 50)
        }
    }
}

struct RecipeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeSelectorView(store: Store(
            initialState: WeekState(allRecipes: .embedded),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }
}
