import ComposableArchitecture

struct IngredientListState: Equatable {
    var ingredients: IdentifiedArrayOf<IngredientState>
}

enum IngredientListAction: Equatable {
    case ingredient(id: Ingredient.ID, action: IngredientAction)
}

let ingredientListReducer = Reducer<IngredientListState, IngredientListAction, IngredientEnvironment>.combine(
    ingredientReducer.forEach(
        state: \.ingredients,
        action: /IngredientListAction.ingredient(id:action:),
        environment: { $0 }
    ),
    Reducer { state, action, environment in
        switch action {
        case .ingredient:
            return .none
        }
    }
)
