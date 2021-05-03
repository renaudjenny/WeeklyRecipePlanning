import ComposableArchitecture

@dynamicMemberLookup
struct RecipeState: Equatable, Identifiable {
    var recipe: Recipe
    var ingredientList: IngredientListState {
        didSet { recipe.ingredients = IdentifiedArrayOf(ingredientList.ingredients.map(\.ingredient)) }
    }

    var id: Recipe.ID { recipe.id }

    init(recipe: Recipe) {
        self.recipe = recipe
        self.ingredientList = IngredientListState(
            ingredients: IdentifiedArrayOf(recipe.ingredients.map { IngredientState(ingredient: $0) })
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
    case addIngredientButtonTapped
    case ingredientsDeleted(IndexSet)
    case ingredientList(IngredientListAction)
}

struct RecipeEnvironment {
    var uuid: () -> UUID
}

let recipeReducer = Reducer<RecipeState, RecipeAction, RecipeEnvironment>.combine(
    ingredientListReducer.pullback(
        state: \.ingredientList,
        action: /RecipeAction.ingredientList,
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
            state.ingredients.remove(atOffsets: indexSet)
            return .none

        case .ingredientList:
            return .none
        }
    }
)

extension Recipe {
    static func new(id: UUID) -> Self {
        Recipe(
            id: id,
            name: "New recipe",
            mealCount: 1,
            ingredients: []
        )
    }
}
