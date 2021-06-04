import ComposableArchitecture

struct WeekState: Equatable {
    var recipes: [Recipe]
    var mealTimeRecipes: [MealTime: Recipe?]
    var mealTimes: IdentifiedArrayOf<MealTimeState>
}

enum WeekAction: Equatable {
    case mealTime(id: MealTime, action: MealTimeAction)
}

struct WeekEnvironment { }

let weekReducer = Reducer<WeekState, WeekAction, WeekEnvironment>.combine(
    mealTimeReducer.forEach(
        state: \.mealTimes,
        action: /WeekAction.mealTime(id:action:),
        environment: { _ in MealTimeEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case let .mealTime(id, action: .recipeSelector):
            guard let newMealTimeRecipes = state.mealTimes[id: id]?.mealTimeRecipes
            else { return .none }

            state.mealTimeRecipes.merge(newMealTimeRecipes, uniquingKeysWith: { $1 })
            state.mealTimes = WeekState.mealTimes(
                recipes: state.recipes,
                mealTimeRecipes: state.mealTimeRecipes
            )
            return .none
        case .mealTime:
            return .none
        }
    }
)

struct MealTimeRecipe: Identifiable, Equatable {
    let mealTime: MealTime
    let recipe: Recipe?

    var id: MealTime { mealTime }
}

extension WeekState {
    static func mealTimes(
        recipes: [Recipe],
        mealTimeRecipes: [MealTime: Recipe?]
    ) -> IdentifiedArrayOf<MealTimeState> {
        IdentifiedArrayOf(MealTime.allCases.map {
            MealTimeState(mealTime: $0, recipes: recipes, mealTimeRecipes: mealTimeRecipes)
        })
    }
}

extension Dictionary where Key == MealTime, Value == Recipe? {
    static let empty: Self = .init(uniqueKeysWithValues: MealTime.allCases.map { ($0, nil) })
}
