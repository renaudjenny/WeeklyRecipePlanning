import ComposableArchitecture

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
