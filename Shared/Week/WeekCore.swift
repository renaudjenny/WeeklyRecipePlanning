import ComposableArchitecture

struct WeekState: Equatable {
    var allRecipes: [Recipe]
    var mealTimeRecipes: [MealTime: Recipe?] = .init(uniqueKeysWithValues: MealTime.allCases.map { ($0, nil) })
    var selectedMealTime: MealTime? = nil

    var recipes: [Recipe] { Array(Set(mealTimeRecipes.values.compactMap { $0 })) }

    // TODO: is it still used?
    var mealTimes: [MealTimeRecipe] { mealTimeRecipes.sorted(by: mealTimeOrdering).map {
        MealTimeRecipe(mealTime: $0, recipe: $1)
    } }

    var mealTimeFilledCount: Int {
        recipes.reduce(0, { $0 + $1.mealCount })
    }

    // TODO: this shall be scoped in the RecipeSelectorState
    var recipesToSelect: [Recipe] {
        allRecipes
            .filter {
                guard let selectedMealTime = selectedMealTime
                else { return true }
                return $0 != mealTimeRecipes[selectedMealTime]
            }
            .sorted(by: inWeekRecipeLast)
    }

    private func inWeekRecipeLast(recipeA: Recipe, recipeB: Recipe) -> Bool {
        if recipes.contains(recipeA) && !recipes.contains(recipeB) {
            return false
        } else if !recipes.contains(recipeA) && recipes.contains(recipeB) {
            return true
        }
        return recipeA.name < recipeB.name
    }

    private func mealTimeOrdering(a: (key: MealTime, value: Recipe?), b: (key: MealTime, value: Recipe?)) -> Bool {
        guard let aMealTimeIndex = MealTime.allCases.firstIndex(of: a.key),
              let bMealTimeIndex = MealTime.allCases.firstIndex(of: b.key)
        else { return true }
        if aMealTimeIndex < bMealTimeIndex {
            return true
        }
        return false
    }
}

enum WeekAction: Equatable {
    case addRecipe(Recipe, MealTime)
    case removeRecipe(Recipe, MealTime)
    case selectMealTime(MealTime)
    case dismissMealTime
}

struct WeekEnvironment {

}

let weekReducer = Reducer<WeekState, WeekAction, WeekEnvironment> { state, action, environment in
    switch action {
    case let .addRecipe(recipe, mealTime):
        print(recipe.name, mealTime.name)

        state.mealTimeRecipes = state.mealTimeRecipes.reduce(state.mealTimeRecipes, { result, next in
            let (key, value) = next
            if key == mealTime {
                var newResult = result
                newResult[mealTime] = recipe
                var remainingMealCount = recipe.mealCount
                print("remainingMealCount before while loop: \(remainingMealCount)")
                while remainingMealCount > 1 {
                    print("remainingMealCount: \(remainingMealCount)")
                    print("next meal: \(mealTime.next.name)")
                    newResult[mealTime.next] = recipe
                    remainingMealCount -= 1
                }
                return newResult
            }
            return result
        })
        return .none
    case let .removeRecipe(recipe, mealTime):
        state.mealTimeRecipes = state.mealTimeRecipes.reduce(state.mealTimeRecipes, { result, next in
            let (key, value) = next
            if key == mealTime, let recipe = value {
                var newResult = result
                newResult[mealTime] = Recipe?.none
                var remainingMealCount = recipe.mealCount
                while remainingMealCount > 0 {
                    newResult[mealTime.next] = Recipe?.none
                    remainingMealCount -= 1
                }
                return newResult
            }
            return result
        })
        return .none
    case let .selectMealTime(mealTime):
        state.selectedMealTime = mealTime
        return .none
    case .dismissMealTime:
        state.selectedMealTime = nil
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
