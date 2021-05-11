import ComposableArchitecture

struct WeekState: Equatable {
    var recipes: [Recipe]
    var week: Week
    var isRecipeListPresented = false

    var mealTimes: [MealTimeRecipe] {
        let weekRecipesByMeals = week.recipes.reduce([]) {
            $0 + Array(repeating: $1, count: $1.mealCount)
        }
        return MealTime.allCases.enumerated().reduce([]) { result, enumeratedElement in
            let (offset, mealTime) = enumeratedElement
            return result + [MealTimeRecipe(mealTime: mealTime, recipe: weekRecipesByMeals[safeIndex: offset])]
        }
    }

    var mealTimeFilledCount: Int {
        week.recipes.reduce(0, { $0 + $1.mealCount })
    }

    var unselectedRecipes: [Recipe] {
        recipes.filter { !week.recipes.contains($0) }
    }

    func isInWeek(recipe: Recipe) -> Bool {
        week.recipes.contains(recipe)
    }
}

enum WeekAction: Equatable {
    case addRecipeButtonTapped
    case addRecipe(Recipe)
    case removeRecipe(Recipe)
}

struct WeekEnvironment {

}

let weekReducer = Reducer<WeekState, WeekAction, WeekEnvironment> { state, action, environment in
    switch action {
    case .addRecipeButtonTapped:
        state.isRecipeListPresented.toggle()
        return .none
    case let .addRecipe(recipe):
        state.week.recipes.append(recipe)
        return .none
    case let .removeRecipe(recipe):
        state.week.recipes = state.week.recipes.filter { $0 != recipe }
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
