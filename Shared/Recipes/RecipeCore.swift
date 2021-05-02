import ComposableArchitecture

@dynamicMemberLookup
struct RecipeState: Equatable, Identifiable {
    var recipe: Recipe
    var ingredientsStates: IdentifiedArrayOf<IngredientState> {
        didSet { recipe.ingredients = IdentifiedArrayOf(ingredientsStates.map(\.ingredient)) }
    }

    var id: Recipe.ID { recipe.id }

    init(recipe: Recipe) {
        self.recipe = recipe
        self.ingredientsStates = IdentifiedArrayOf(recipe.ingredients.map { IngredientState(ingredient: $0) })
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
    case ingredient(id: Ingredient.ID, action: IngredientAction)
}

struct RecipeEnvironment {
    var uuid: () -> UUID
}

let recipeReducer = Reducer<RecipeState, RecipeAction, RecipeEnvironment>.combine(
    ingredientReducer.forEach(
        state: \.ingredientsStates,
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
            state.ingredientsStates.insert(.new(id: environment.uuid()), at: 0)
            return .none
        case let .ingredientsDeleted(indexSet):
            state.ingredients.remove(atOffsets: indexSet)
            return .none

        case .ingredient:
            return .none
        }
    }
)

@dynamicMemberLookup
struct IngredientState: Equatable, Identifiable {
    var ingredient: Ingredient
    var isUnitInEditionMode = false

    var id: Ingredient.ID { ingredient.id }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<Ingredient, T>) -> T {
        get { ingredient[keyPath: keyPath] }
        set { ingredient[keyPath: keyPath] = newValue }
    }
}

enum IngredientAction: Equatable {
    case nameChanged(String)
    case quantityChanged(String)
    case unitChanged(Unit?)

    case unitButtonTapped
    case quantityFormatError
}

struct IngredientEnvironment { }

let ingredientReducer = Reducer<IngredientState, IngredientAction, IngredientEnvironment> { state, action, environment in
    switch action {
    case let .nameChanged(name):
        state.name = name
        return .none
    case let .quantityChanged(quantity):
        guard let quantity = quantity.doubleValue
        else { return Effect(value: .quantityFormatError) }

        state.quantity = quantity
        return .none
    case let .unitChanged(unit):
        state.unit = unit
        return .none

    case .unitButtonTapped:
        state.isUnitInEditionMode = !state.isUnitInEditionMode
        return .none

    case .quantityFormatError:
        return .none
    }
}

extension RecipeState {
    static func new(id: UUID) -> Self {
        RecipeState(recipe: Recipe(
            id: id,
            name: "New recipe",
            mealCount: 1,
            ingredients: []
        ))
    }
}

extension IngredientState {
    static func new(id: UUID) -> Self {
        IngredientState(ingredient: Ingredient(
            id: id,
            name: "New ingredient",
            quantity: 100,
            unit: UnitVolume.centiliters
        ))
    }
}

private extension String {
    var doubleValue: Double? { numberFormatterDecimal.number(from: self)?.doubleValue }
}
