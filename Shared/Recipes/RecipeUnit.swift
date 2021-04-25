import Foundation

/// Selection of some Unit useful for IngredientView
enum RecipeUnit: RawRepresentable, Identifiable, CaseIterable {
    typealias RawValue = Unit?

    case none

    // Volumes
    case centiliters
    case liters

    // Mass
    case grams

    var unit: Unit? {
        switch self {
        case .none: return nil

        // Volumes
        case .centiliters: return UnitVolume.centiliters
        case .liters: return UnitVolume.liters

        // Mass
        case .grams: return UnitMass.grams
        }
    }

    init?(rawValue: Unit?) {
        if let foundUnit = RecipeUnit.allCases.first(where: { $0.rawValue == rawValue }) {
            self = foundUnit
        } else {
            return nil
        }
    }

    var text: String { unit?.symbol ?? "-" }
    var rawValue: RawValue { unit }
    var id: String { text }
}
