import ComposableArchitecture

struct WeekState: Equatable {
    var week: Week
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
}

enum WeekAction: Equatable {
    case addRecipeButtonTapped
    case removeRecipe(Recipe)
}

struct WeekEnvironment {

}

let weekReducer = Reducer<WeekState, WeekAction, WeekEnvironment> { state, action, environment in
    switch action {
    case .addRecipeButtonTapped:
        print("Add recipe button tapped")
        return .none
    case let .removeRecipe(recipe):
        print("Remove recipe: \(recipe.name)")
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
