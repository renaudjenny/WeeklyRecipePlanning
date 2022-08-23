import ComposableArchitecture

@dynamicMemberLookup
struct RecipeState: Equatable, Identifiable {
    var recipe: Recipe
    var ingredientList: IngredientListState

    var id: Recipe.ID { recipe.id }

    init(recipe: Recipe) {
        self.recipe = recipe
        self.ingredientList = IngredientListState(
            ingredients: IdentifiedArrayOf(uniqueElements: recipe.ingredients.map {
                IngredientState(ingredient: $0)
            })
        )
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<Recipe, T>) -> T {
        get { recipe[keyPath: keyPath] }
        set { recipe[keyPath: keyPath] = newValue }
    }
}

enum RecipeAction: Equatable {
    case nameChanged(String)
    case mealCountChanged(Int)
    case ingredientList(IngredientListAction)
}

struct RecipeEnvironment {
    var uuid: () -> UUID
}

let recipeReducer = Reducer<RecipeState, RecipeAction, RecipeEnvironment>.combine(
    ingredientListReducer.pullback(
        state: \.ingredientList,
        action: /RecipeAction.ingredientList,
        environment: { IngredientListEnvironment(uuid: $0.uuid) }
    ),
    Reducer { state, action, environment in
        switch action {
        case let .nameChanged(name):
            state.name = name
            return .none
        case let .mealCountChanged(mealCount):
            state.mealCount = mealCount
            return .none

        case .ingredientList:
            state.ingredients = IdentifiedArrayOf(
                uniqueElements: state.ingredientList.ingredients.map(\.ingredient)
            )
            return .none
        }
    }
)

extension Recipe {
    static func new(id: UUID) -> Self {
        Recipe(
            id: id,
            name: "",
            mealCount: 1,
            ingredients: []
        )
    }
}
