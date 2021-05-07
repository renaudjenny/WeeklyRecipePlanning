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
                    }
                }
                ProgressView(
                    "Planning completion",
                    value: Double(viewStore.mealTimeFilledCount),
                    total: Double(MealTime.allCases.count)
                )
                .padding()
                LazyVStack {
                    ForEach(MealTime.allCases, content: MealTimeView.init)
                }
            }
        }
    }

    func recipesHeader(store: Store<WeekState, WeekAction>) -> some View {
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

    func recipeCell(_ recipe: Recipe, store: Store<WeekState, WeekAction>) -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text(recipe.name)
                Button { viewStore.send(.removeRecipe(recipe)) } label: {
                    Image(systemName: "minus")
                }
                .frame(width: 50, height: 50)
                .background(Color.accentColor.opacity(0.10))
                .clipShape(Circle())
            }
            .padding(4)
            .background(Color.accentColor.opacity(0.10))
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(store: Store(
            initialState: WeekState(week: Week(recipes: .embedded)),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }
}
