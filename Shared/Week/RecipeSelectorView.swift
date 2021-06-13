import ComposableArchitecture
import SwiftUI

struct RecipeSelectorView: View {
    let store: Store<RecipeSelectorState, RecipeSelectorAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                header(
                    mealTime: viewStore.mealTime,
                    mealTimeRecipes: viewStore.mealTimeRecipes,
                    removeRecipe: { viewStore.send(.removeRecipe, animation: .default) }
                )

                recipesList(
                    recipesToDisplay: viewStore.recipesToDisplay,
                    mealTimeRecipes: viewStore.mealTimeRecipes,
                    setRecipe: { viewStore.send(.setRecipe($0), animation: .default) }
                )
            }
            .padding()
        }
    }

    private func header(
        mealTime: MealTime,
        mealTimeRecipes: [MealTime: Recipe?],
        removeRecipe: @escaping () -> Void
    ) -> some View {
        VStack {
            Text(mealTime.name)
                .font(.title)
            HStack {
                Spacer()
                selectedRecipeText(for: mealTime, mealTimeRecipes: mealTimeRecipes)
                    .font(.subheadline)
                Spacer()
                if mealTimeRecipes[mealTime] != Recipe?.none {
                    Button(action: removeRecipe) {
                        Image(systemName: "trash")
                    }
                }
            }
            .padding(.vertical)
        }
    }

    private func selectedRecipeText(
        for mealTime: MealTime,
        mealTimeRecipes: [MealTime: Recipe?]
    ) -> some View {
        Group {
            if let possibleRecipe = mealTimeRecipes[mealTime], let recipe = possibleRecipe {
                VStack {
                    Text("\(recipe.name)")

                    recipeAlsoUsedInMealTimes(
                        recipe: recipe,
                        exclude: mealTime,
                        mealTimeRecipes: mealTimeRecipes
                    )
                    .font(.caption)
                }
            } else {
                Text("Please, select a recipe for this meal time in the list")
            }
        }
    }

    private func recipeAlsoUsedInMealTimes(
        recipe: Recipe,
        exclude mealTime: MealTime,
        mealTimeRecipes: [MealTime: Recipe?]
    ) -> some View {
        let alsoUsedInMealTimes = ListFormatter.localizedString(
            byJoining: mealTimeRecipes.mealTimes(for: recipe)
                .filter { $0 != mealTime }
                .map(\.name)
        )

        return Group {
            if alsoUsedInMealTimes.count > 0 {
                Text("This recipe will also be used for \(alsoUsedInMealTimes)")
            } else {
                EmptyView()
            }
        }
    }

    private func recipesList(
        recipesToDisplay: [Recipe],
        mealTimeRecipes: [MealTime: Recipe?],
        setRecipe: @escaping (Recipe) -> Void
    ) -> some View {
        LazyVStack(alignment: .leading) {
            ForEach(recipesToDisplay) { recipe in
                Button { setRecipe(recipe) } label: {
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .foregroundColor(
                                mealTimeRecipes.values.contains(recipe)
                                    ? .secondary
                                    : .primary
                            )
                        recipeAlsoUsedInMealTimes(recipe: recipe, mealTimeRecipes: mealTimeRecipes)
                            .font(.caption2)
                            .foregroundColor(
                                mealTimeRecipes.values.contains(recipe)
                                    ? .secondary
                                    : .primary
                            )
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 4)
            }
        }
    }

    private func recipeAlsoUsedInMealTimes(
        recipe: Recipe,
        mealTimeRecipes: [MealTime: Recipe?]
    ) -> some View {
        let alsoUsedInMealTimes = ListFormatter.localizedString(
            byJoining: mealTimeRecipes.mealTimes(for: recipe)
                .map(\.name)
        )

        return Group {
            if alsoUsedInMealTimes.count > 0 {
                Text("This recipe is already used for \(alsoUsedInMealTimes)")
            } else {
                EmptyView()
            }
        }
    }
}

struct RecipeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeSelectorView(store: Store(
            initialState: RecipeSelectorState(
                mealTime: .sundayDinner,
                recipes: .embedded,
                mealTimeRecipes: .init(uniqueKeysWithValues: MealTime.allCases.map {
                    switch $0 {
                    case .sundayDinner: return ($0, [Recipe].embedded.first)
                    case .mondayLunch: return ($0, [Recipe].embedded.first)
                    case .wednesdayDinner: return ($0, [Recipe].embedded.last)
                    default: return ($0, nil)
                    }
                })
            ),
            reducer: recipeSelectorReducer,
            environment: RecipeSelectorEnvironment()
        ))

        RecipeSelectorView(store: Store(
            initialState: RecipeSelectorState(
                mealTime: .sundayLunch,
                recipes: .embedded,
                mealTimeRecipes: .init(uniqueKeysWithValues: MealTime.allCases.map {
                    switch $0 {
                    case .sundayDinner: return ($0, [Recipe].embedded.first)
                    case .mondayLunch: return ($0, [Recipe].embedded.first)
                    case .wednesdayDinner: return ($0, [Recipe].embedded.last)
                    default: return ($0, nil)
                    }
                })
            ),
            reducer: recipeSelectorReducer,
            environment: RecipeSelectorEnvironment()
        ))
    }
}
