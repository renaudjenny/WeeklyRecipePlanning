import Foundation

let recipes: [Recipe] = [
    Recipe(name: "Pâtes aux poireaux", mealCount: 2, ingredients: [
        Ingredient(name: "Poireau", quantity: 3),
        Ingredient(name: "Pasta", quantity: 500, unit: UnitMass.grams),
        Ingredient(name: "Cheddar", quantity: 50, unit: UnitMass.grams),
        Ingredient(name: "Red Leicester", quantity: 50, unit: UnitMass.grams),
        Ingredient(name: "Wine", quantity: 10, unit: UnitVolume.centiliters),
        Ingredient(name: "Cream", quantity: 25, unit: UnitVolume.centiliters),
        Ingredient(name: "Corn flour", quantity: 1, unit: UnitVolume.tablespoons),
    ]),
    Recipe(name: "Pâtes aux champignons", mealCount: 2, ingredients: [
        Ingredient(name: "Mushrooms", quantity: 100, unit: UnitMass.grams),
        Ingredient(name: "Pasta", quantity: 500, unit: UnitMass.grams),
        Ingredient(name: "Cheddar", quantity: 50, unit: UnitMass.grams),
        Ingredient(name: "Red Leicester", quantity: 50, unit: UnitMass.grams),
        Ingredient(name: "Wine", quantity: 10, unit: UnitVolume.centiliters),
        Ingredient(name: "Cream", quantity: 25, unit: UnitVolume.centiliters),
        Ingredient(name: "Corn flour", quantity: 1, unit: UnitVolume.tablespoons),
    ]),
    Recipe(name: "Crêpes", mealCount: 1, ingredients: [
        Ingredient(name: "Floor", quantity: 300, unit: UnitVolume.centiliters),
        Ingredient(name: "Egg", quantity: 1),
        Ingredient(name: "Milk", quantity: 50, unit: UnitVolume.centiliters),
        Ingredient(name: "Rhum", quantity: 4, unit: UnitVolume.tablespoons),
        Ingredient(name: "Vanilla extract", quantity: 0.5, unit: UnitVolume.teaspoons),
    ]),
]

struct Recipe: Codable {
    let name: String
    let mealCount: Int
    var ingredients: [Ingredient]

    static let error = Recipe(name: "Error", mealCount: 0, ingredients: [])
}

struct Ingredient: Codable {
    let name: String
    let quantity: Double
    private(set) var unit: Unit? = nil

    init(name: String, quantity: Double, unit: Unit? = nil) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }

    enum CodingKeys: String, CodingKey {
        case name
        case quantity
        case unit
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        quantity = try values.decode(Double.self, forKey: .quantity)

        guard let unitData = try values.decodeIfPresent(Data.self, forKey: .unit)
        else { return }
        unit = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unitData) as? Unit
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let formattedNumber = formatter.string(from: NSNumber(value: ingredient.quantity)) {
            appendLiteral(formattedNumber)
        }
        if let unitSymbol = ingredient.unit?.symbol {
            appendLiteral(" \(unitSymbol)")
        }
    }
}
