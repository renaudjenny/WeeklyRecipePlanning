import ComposableArchitecture

struct WeekState: Equatable {
    var allRecipes: [Recipe]
    var recipes: [Recipe]
    var isRecipeListPresented = false

    var mealTimes: [MealTimeRecipe] {
        let weekRecipesByMeals = recipes.reduce([]) {
            $0 + Array(repeating: $1, count: $1.mealCount)
        }
        return MealTime.allCases.enumerated().reduce([]) { result, enumeratedElement in
            let (offset, mealTime) = enumeratedElement
            return result + [MealTimeRecipe(mealTime: mealTime, recipe: weekRecipesByMeals[safeIndex: offset])]
        }
    }

    var mealTimeFilledCount: Int {
        recipes.reduce(0, { $0 + $1.mealCount })
    }

    var displayedRecipes: [Recipe] {
        isRecipeListPresented
            ? allRecipes.sorted(by: inWeekRecipeLast)
            : recipes
    }

    private func inWeekRecipeLast(recipeA: Recipe, recipeB: Recipe) -> Bool {
        if recipes.contains(recipeA) && !recipes.contains(recipeB) {
            return false
        } else if !recipes.contains(recipeA) && recipes.contains(recipeB) {
            return true
        }
        return recipeA.name < recipeB.name
    }
}

enum WeekAction: Equatable {
    case showHideAllRecipesButtonTapped
    case addRecipe(Recipe)
    case removeRecipe(Recipe)
}

struct WeekEnvironment {

}

let weekReducer = Reducer<WeekState, WeekAction, WeekEnvironment> { state, action, environment in
    switch action {
    case .showHideAllRecipesButtonTapped:
        state.isRecipeListPresented.toggle()
        return .none
    case let .addRecipe(recipe):
        state.recipes.append(recipe)
        return .none
    case let .removeRecipe(recipe):
        state.recipes = state.recipes.filter { $0 != recipe }
        return .none
    }
}

struct MealTimeRecipe: Identifiable, Equatable {
    let mealTime: MealTime
    let recipe: Recipe?

    var id: MealTime { mealTime }
}

private extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard indices.contains(index)
        else { return nil }
        return self[index]
    }
}
