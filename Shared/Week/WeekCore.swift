import ComposableArchitecture

struct WeekState: Equatable {
    var allRecipes: [Recipe]
    var mealTimeRecipes: [MealTime: Recipe?] = .init(uniqueKeysWithValues: MealTime.allCases.map { ($0, nil) })
    var selectedMealTime: MealTime? = nil

    var recipeSelector: RecipeSelectorState? {
        get {
            guard let mealTime = selectedMealTime
            else { return nil }
            return RecipeSelectorState(
                mealTime: mealTime,
                recipes: allRecipes,
                mealTimeRecipes: mealTimeRecipes
            )
        }
        set {
            guard let recipeSelector = newValue
            else { return }
            mealTimeRecipes = recipeSelector.mealTimeRecipes
        }
    }

    var mealTimeFilledCount: Int {
        mealTimeRecipes.values
            .compactMap { $0 }
            .reduce(0, { $0 + $1.mealCount })
    }
}

enum WeekAction: Equatable {
    case selectMealTime(MealTime)
    case dismissMealTime
    case recipeSelector(RecipeSelectorAction)
}

struct WeekEnvironment { }

let weekReducer = Reducer<WeekState, WeekAction, WeekEnvironment> { state, action, environment in
    switch action {
    case let .selectMealTime(mealTime):
        state.selectedMealTime = mealTime
        return .none
    case .dismissMealTime:
        state.selectedMealTime = nil
        return .none
    case .recipeSelector:
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
