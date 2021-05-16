import ComposableArchitecture
import Foundation

struct Recipe: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var mealCount: Int
    var ingredients: IdentifiedArrayOf<Ingredient>

    static let error = Recipe(id: UUID(), name: "Error", mealCount: 0, ingredients: [])
}

struct Ingredient: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var quantity: Double
    var unit: Unit? = nil

    init(id: UUID, name: String, quantity: Double, unit: Unit? = nil) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case quantity
        case unit
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        quantity = try values.decode(Double.self, forKey: .quantity)

        guard let unitData = try values.decodeIfPresent(Data.self, forKey: .unit)
        else { return }
        unit = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unitData) as? Unit
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)

        guard let unit = unit
        else { return }
        let unitData = try NSKeyedArchiver.archivedData(withRootObject: unit, requiringSecureCoding: false)
        try container.encode(unitData, forKey: .unit)
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ ingredient: Ingredient) {
        if let formattedNumber = numberFormatterDecimal.string(from: NSNumber(value: ingredient.quantity)) {
            appendLiteral(formattedNumber)
        }
        if let unitSymbol = ingredient.unit?.symbol {
            appendLiteral(" \(unitSymbol)")
        }
    }
}

let numberFormatterDecimal: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = "."
    return formatter
}()
