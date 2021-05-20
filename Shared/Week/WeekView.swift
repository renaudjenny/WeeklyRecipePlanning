import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    let store: Store<WeekState, WeekAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ProgressView(
                    "Planning completion",
                    value: Double(viewStore.mealTimeFilledCount),
                    total: Double(MealTime.allCases.count)
                )
                .padding()

                Form {
                    Section(header: Text("Number of different recipes: \(viewStore.recipes.count)")) {
                        List {
                            ForEach(viewStore.displayedRecipes) { recipe in
                                recipeCell(recipe, viewStore: viewStore)
                            }
                        }
                        Button { viewStore.send(.showHideAllRecipesButtonTapped, animation: .default) } label: {
                            Text(
                                viewStore.isRecipeListPresented
                                    ? "Show only week recipes"
                                    : "Show all available recipes"
                            )
                        }
                    }
                    Section {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewStore.mealTimes) { mealTimeRecipe in
                                MealTimeView(mealTimeRecipe: mealTimeRecipe)
                            }
                        }
                        .padding()
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
                if viewStore.recipes.contains(recipe) {
                    viewStore.send(.removeRecipe(recipe), animation: .default)
                } else {
                    viewStore.send(.addRecipe(recipe), animation: .default)
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

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(store: Store(
            initialState: WeekState(allRecipes: .embedded, recipes: [Recipe].embedded.dropLast()),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }
}
