import ComposableArchitecture

struct RecipeSelectorState: Equatable {
    let mealTime: MealTime
    var mealTimeRecipes: [MealTime: Recipe?] = [:]
}

enum RecipeSelectorAction: Equatable {
    case setRecipe(Recipe)
    case removeRecipe
}

struct RecipeSelectorEnvironment { }

let recipeSelectorReducer = Reducer<RecipeSelectorState, RecipeSelectorAction, RecipeSelectorEnvironment> { state, action, environment in
    switch action {
    case let .setRecipe(recipe):
        let mealTimeRecipesToChange = (0..<recipe.mealCount).map {
            (state.mealTime.next(count: $0), recipe)
        }
        state.mealTimeRecipes.merge(mealTimeRecipesToChange, uniquingKeysWith: { $1 })
        return .none
    case .removeRecipe:
        guard let potentialRecipe = state.mealTimeRecipes[state.mealTime],
              let recipe = potentialRecipe
        else { return .none }
        let mealTimeRecipesToChange = (0..<recipe.mealCount).map {
            (state.mealTime.next(count: $0), Recipe?.none)
        }
        state.mealTimeRecipes.merge(mealTimeRecipesToChange, uniquingKeysWith: { $1 })
        return .none
    }
}

private extension MealTime {
    func next(count: Int) -> Self {
        guard let index = MealTime.allCases.firstIndex(of: self)
        else { fatalError("Cannot retrieve the index of MealTime all cases for \(self.name)") }

        if count <= 0 {
            return MealTime.allCases[index]
        } else if MealTime.allCases.endIndex > index + 1 {
            return MealTime.allCases[index + 1].next(count: count - 1)
        } else {
            return MealTime.allCases[0].next(count: count - 1)
        }
    }
}
