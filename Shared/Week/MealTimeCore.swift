import ComposableArchitecture

struct MealTimeState: Equatable, Identifiable {
    var mealTime: MealTime
    var recipes: [Recipe]
    var mealTimeRecipes: [MealTime: Recipe?]
    var recipeSelector: RecipeSelectorState?

    var id: MealTime { mealTime }

    var recipe: Recipe? { mealTimeRecipes[mealTime] ?? nil }
}

enum MealTimeAction: Equatable {
    case mealTimeTapped
    case dismissRecipeSelector
    case recipeSelector(RecipeSelectorAction)
}

struct MealTimeEnvironment { }

let mealTimeReducer = Reducer<MealTimeState, MealTimeAction, MealTimeEnvironment>.combine(
    recipeSelectorReducer
        .optional()
        .pullback(
            state: \.recipeSelector,
            action: /MealTimeAction.recipeSelector,
            environment: { _ in RecipeSelectorEnvironment() }
        ),
    Reducer { state, action, environment in
        switch action {
        case .mealTimeTapped:
            state.recipeSelector = RecipeSelectorState(
                mealTime: state.mealTime,
                recipes: state.recipes,
                mealTimeRecipes: state.mealTimeRecipes
            )
            return .none
        case .dismissRecipeSelector:
            state.recipeSelector = nil
            return .none
        case .recipeSelector:
            guard let newMealTimeRecipes = state.recipeSelector?.mealTimeRecipes
            else { return .none }
            state.mealTimeRecipes = newMealTimeRecipes
            return .none
        }
    }
)
