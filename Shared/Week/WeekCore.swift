import ComposableArchitecture

struct WeekState: Equatable {
    var week: Week
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
