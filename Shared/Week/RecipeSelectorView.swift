import ComposableArchitecture
import SwiftUI

struct RecipeSelectorView: View {
    // TODO: this View should have it's scoped store
    let store: Store<WeekState, WeekAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            if let selectedMealTime = viewStore.selectedMealTime {
                ScrollView {
                    Text("\(viewStore.selectedMealTime?.name ?? "?")")
                        .font(.title)
                    HStack {
                        Spacer()
                        selectedRecipeText(for: selectedMealTime, mealTimeRecipes: viewStore.mealTimeRecipes)
                            .font(.subheadline)
                        Spacer()
                        if let possibleRecipe = viewStore.mealTimeRecipes[selectedMealTime], let recipe = possibleRecipe {
                            Button {
                                viewStore.send(.removeRecipe(recipe, selectedMealTime), animation: .default)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.6))
                                    Image(systemName: "minus")
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 50, height: 50)
                        }
                    }
                    .padding(.vertical)
                    LazyVStack {
                        ForEach(viewStore.recipesToSelect) { recipe in
                            recipeCell(recipe, mealTime: selectedMealTime, viewStore: viewStore)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private func recipeCell(_ recipe: Recipe, mealTime: MealTime, viewStore: ViewStore<WeekState, WeekAction>) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.name)
                recipeAlsoUsedInMealTimes(recipe: recipe, mealTime: mealTime, mealTimeRecipes: viewStore.mealTimeRecipes)
                    .font(.caption2)
            }
            .foregroundColor(viewStore.recipes.contains(recipe) ? .secondary : .primary)

            Spacer()
            Button { viewStore.send(.addRecipe(recipe, mealTime), animation: .default) } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.accentColor)
                    Image(systemName: "plus")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 50, height: 50)
        }
    }

    // TODO: The logic shall be part of the scoped state
    private func selectedRecipeText(for mealTime: MealTime, mealTimeRecipes: [MealTime: Recipe?]) -> some View {
        Group {
            if let possibleRecipe = mealTimeRecipes[mealTime], let recipe = possibleRecipe {
                VStack {
                    Text("\(recipe.name)")
                    recipeAlsoUsedInMealTimes(recipe: recipe, mealTime: mealTime, mealTimeRecipes: mealTimeRecipes)
                        .font(.caption)
                }
            } else {
                Text("Please, select a recipe for this meal time in the list")
            }
        }
    }

    // TODO: The logic shall be part of the scoped state
    private func recipeAlsoUsedInMealTimes(recipe: Recipe, mealTime: MealTime, mealTimeRecipes: [MealTime: Recipe?]) -> some View {
        let alsoUsedInMealTimes = mealTimeRecipes
            .filter { $0.value == recipe && $0.key != mealTime }
            .keys
            .map { $0.name }

        return Group {
            if alsoUsedInMealTimes.count > 0 {
                Text("This recipe will also be used for \(ListFormatter.localizedString(byJoining: alsoUsedInMealTimes))")
            } else {
                EmptyView()
            }
        }
    }
}

struct RecipeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeSelectorView(store: Store(
            initialState: WeekState(
                allRecipes: .embedded,
                mealTimeRecipes: .init(uniqueKeysWithValues: MealTime.allCases.map {
                    switch $0 {
                    case .sundayDinner: return ($0, [Recipe].embedded.first)
                    case .mondayLunch: return ($0, [Recipe].embedded.first)
                    case .wednesdayDinner: return ($0, [Recipe].embedded.last)
                    default: return ($0, nil)
                    }
                }),
                selectedMealTime: .sundayDinner
            ),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))

        RecipeSelectorView(store: Store(
            initialState: WeekState(
                allRecipes: .embedded,
                mealTimeRecipes: .init(uniqueKeysWithValues: MealTime.allCases.map {
                    switch $0 {
                    case .sundayDinner: return ($0, [Recipe].embedded.first)
                    case .mondayLunch: return ($0, [Recipe].embedded.first)
                    case .wednesdayDinner: return ($0, [Recipe].embedded.last)
                    default: return ($0, nil)
                    }
                }),
                selectedMealTime: .sundayLunch
            ),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }
}
