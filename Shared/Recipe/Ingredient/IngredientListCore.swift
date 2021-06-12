import ComposableArchitecture

struct IngredientListState: Equatable {
    var ingredients: IdentifiedArrayOf<IngredientState>
}

enum IngredientListAction: Equatable {
    case addButtonTapped
    case delete(IndexSet)
    case ingredient(id: Ingredient.ID, action: IngredientAction)
}

struct IngredientListEnvironment {
    var uuid: () -> UUID
}

let ingredientListReducer = Reducer<
    IngredientListState,
    IngredientListAction,
    IngredientListEnvironment
>.combine(
    ingredientReducer.forEach(
        state: \.ingredients,
        action: /IngredientListAction.ingredient(id:action:),
        environment: { _ in IngredientEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .addButtonTapped:
            state.ingredients.insert(
                IngredientState(ingredient: .new(id: environment.uuid())),
                at: 0
            )
            return .none
        case let .delete(indexSet):
            state.ingredients.remove(atOffsets: indexSet)
            return .none

        case .ingredient:
            return .none
        }
    }
)
