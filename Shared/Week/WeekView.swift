import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    let store: Store<WeekState, WeekAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section(header: recipesHeader(store: store)) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], alignment: .leading, spacing: 8) {
                        ForEach(viewStore.week.recipes) { recipe in
                            recipeCell(recipe, store: store)
                        }
                        ForEach(viewStore.unselectedRecipes) { recipe in
                            recipeCell(recipe, store: store)
                        }
                    }
                }
                Section {
                    ProgressView(
                        "Planning completion",
                        value: Double(viewStore.mealTimeFilledCount),
                        total: Double(MealTime.allCases.count)
                    )
                    .padding()
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

    private func recipesHeader(store: Store<WeekState, WeekAction>) -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text("Number of different recipes: \(viewStore.week.recipes.count)")
                Spacer()
                Button { viewStore.send(.addRecipeButtonTapped) } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func recipeCell(_ recipe: Recipe, store: Store<WeekState, WeekAction>) -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text(recipe.name)
                    .foregroundColor(viewStore.state.isInWeek(recipe: recipe) ? .primary : .secondary)
                Button {
                    if viewStore.state.isInWeek(recipe: recipe) {
                        viewStore.send(.removeRecipe(recipe))
                    } else {
                        viewStore.send(.addRecipe(recipe))
                    }
                } label: {
                    ZStack {
                        Circle().fill(
                            viewStore.state.isInWeek(recipe: recipe)
                                ? Color.red.opacity(0.10)
                                : Color.accentColor.opacity(0.10)
                        )
                        Image(systemName: viewStore.state.isInWeek(recipe: recipe) ? "minus" : "plus")
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 50, height: 50)
            }
            .padding(4)
            .background(
                viewStore.state.isInWeek(recipe: recipe)
                    ? Color.accentColor.opacity(0.10)
                    : Color.gray.opacity(0.10)
            )
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(store: Store(
            initialState: WeekState(
                recipes: .embedded,
                week: Week(recipes: [Recipe].embedded.dropLast())
            ),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }
}
