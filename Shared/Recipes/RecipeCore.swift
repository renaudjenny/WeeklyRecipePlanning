import ComposableArchitecture

enum RecipeAction: Equatable {
    case nameChanged(String)
    case mealCountChanged(Int)
    case addIngredientButtonTapped
    case ingredientsDeleted(IndexSet)
    case ingredient(id: Ingredient.ID, action: IngredientAction)
}

struct RecipeEnvironment {
    var uuid: () -> UUID
}

let recipeReducer = Reducer<Recipe, RecipeAction, RecipeEnvironment>.combine(
    ingredientReducer.forEach(
        state: \.ingredients,
        action: /RecipeAction.ingredient(id:action:),
        environment: { _ in IngredientEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case let .nameChanged(name):
            state.name = name
            return .none
        case let .mealCountChanged(mealCount):
            state.mealCount = mealCount
            return .none

        case .addIngredientButtonTapped:
            state.ingredients.insert(.new(id: environment.uuid()), at: 0)
            return .none
        case let .ingredientsDeleted(indexSet):
            return .none

        case .ingredient:
            return .none
        }
    }
)

enum IngredientAction: Equatable {
    case nameChanged(String)
    case quantityChanged(String)
    case unitChanged(Unit?)
}

struct IngredientEnvironment { }

let ingredientReducer = Reducer<Ingredient, IngredientAction, IngredientEnvironment> { state, action, environment in
    switch action {
    case let .nameChanged(name):
        return .none
    case let .quantityChanged(quantity):
        return .none
    case let .unitChanged(unit):
        return .none
    }
}