import ComposableArchitecture

@dynamicMemberLookup
struct RecipeState: Equatable, Identifiable {
    var recipe: Recipe
    var ingredientsUnitInEditMode: [Ingredient.ID: Bool] = [:]

    var id: Recipe.ID { recipe.id }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<Recipe, T>) -> T {
        get { recipe[keyPath: keyPath] }
        set { recipe[keyPath: keyPath] = newValue }
    }
}

extension RecipeState {
    var ingredientList: IngredientListState {
        get { IngredientListState(ingredients: recipe.ingredients, unitsInEditionMode: ingredientsUnitInEditMode) }
        set {
            recipe.ingredients = newValue.ingredients
            ingredientsUnitInEditMode = newValue.unitsInEditionMode
        }
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

struct IngredientListState: Equatable {
    var ingredients: IdentifiedArrayOf<Ingredient>
    var unitsInEditionMode: [Ingredient.ID: Bool] = [:]
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
        case let .ingredient(id: id, action: .unitButtonTapped):
            state.unitsInEditionMode[id] = !(state.unitsInEditionMode[id] ?? false)
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

    case unitButtonTapped
    case quantityFormatError
}

struct IngredientEnvironment { }

let ingredientReducer = Reducer<Ingredient, IngredientAction, IngredientEnvironment> { state, action, environment in
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
        return .none

    case .quantityFormatError:
        return .none
    }
}

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

extension Ingredient {
    static func new(id: UUID) -> Self {
        Ingredient(
            id: id,
            name: "New ingredient",
            quantity: 100,
            unit: UnitVolume.centiliters
        )
    }
}

private extension String {
    var doubleValue: Double? { numberFormatterDecimal.number(from: self)?.doubleValue }
}
