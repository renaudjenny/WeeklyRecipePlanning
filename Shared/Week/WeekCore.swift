import ComposableArchitecture

struct WeekState: Equatable {
    var week: Week
}

enum WeekAction: Equatable {
    case addRecipe(Recipe)
}

struct WeekEnvironment {

}

let weekReducer = Reducer<WeekState, WeekAction, WeekEnvironment> { state, action, environment in
    switch action {
    case let .addRecipe(recipe):
        print("Recipe added: \(recipe)")
        return .none
    }
}
