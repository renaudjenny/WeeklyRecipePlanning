import Foundation

extension Array where Element == Recipe {
    static let test: Self = [
        Recipe(id: UUID(uuidString: "B3EBE9FB-6B5C-44B0-AA64-C8AB23480493") ?? UUID(), name: "Recipe A", mealCount: 2, ingredients: [
            Ingredient(id: UUID(uuidString: "FB7CCCB8-71A5-4629-B691-5B517A74D69F") ?? UUID(), name: "Leek", quantity: 3),
            Ingredient(id: UUID(uuidString: "16E95A65-998B-4A49-9ADA-BFA4D232C592") ?? UUID(), name: "Pasta", quantity: 500, unit: UnitMass.grams),
            Ingredient(id: UUID(uuidString: "1B57A1D5-8734-44D0-9831-ACB7A7BC39CB") ?? UUID(), name: "Cheddar", quantity: 50, unit: UnitMass.grams),
            Ingredient(id: UUID(uuidString: "68F6D7B0-A148-4C70-8C33-981858EC648E") ?? UUID(), name: "Red Leicester", quantity: 50, unit: UnitMass.grams),
            Ingredient(id: UUID(uuidString: "B40E786D-D38B-4C9D-855D-F00B7278974C") ?? UUID(), name: "Wine", quantity: 5, unit: UnitVolume.centiliters),
            Ingredient(id: UUID(uuidString: "ABC7F3A7-6A62-4B41-A639-953703CCB82E") ?? UUID(), name: "Cream", quantity: 25, unit: UnitVolume.centiliters),
            Ingredient(id: UUID(uuidString: "3FBA334B-37DD-4B41-AE5D-83CEEC270BF6") ?? UUID(), name: "Corn flour", quantity: 1, unit: UnitVolume.tablespoons),
        ]),
        Recipe(id: UUID(uuidString: "6B950EE7-ECB1-406A-975E-CA6ADDB70CD9") ?? UUID(), name: "Recipe B", mealCount: 2, ingredients: [
            Ingredient(id: UUID(uuidString: "261AE567-6BC0-4AEF-8FE1-F059220822CF") ?? UUID(), name: "Mushrooms", quantity: 100, unit: UnitMass.grams),
            Ingredient(id: UUID(uuidString: "2571E661-731A-41F8-8A5A-B474DB8DFA67") ?? UUID(), name: "Pasta", quantity: 500, unit: UnitMass.grams),
            Ingredient(id: UUID(uuidString: "4A11F14F-64CF-4497-9450-22E9F0721D41") ?? UUID(), name: "Cheddar", quantity: 50, unit: UnitMass.grams),
            Ingredient(id: UUID(uuidString: "9D65F21B-55D5-407B-8C06-C9176DE74A5E") ?? UUID(), name: "Red Leicester", quantity: 50, unit: UnitMass.grams),
            Ingredient(id: UUID(uuidString: "DAA1E080-8739-452F-AFD4-995FB2D6677E") ?? UUID(), name: "Wine", quantity: 5, unit: UnitVolume.centiliters),
            Ingredient(id: UUID(uuidString: "A7D1A904-8AFC-4274-AB07-42A1D0E77F55") ?? UUID(), name: "Cream", quantity: 25, unit: UnitVolume.centiliters),
            Ingredient(id: UUID(uuidString: "DC471048-6C92-4A95-982A-C25A5FA9F1C5") ?? UUID(), name: "Corn flour", quantity: 1, unit: UnitVolume.tablespoons),
            Ingredient(id: UUID(uuidString: "F6691519-FE51-4264-8628-D2D79F058719") ?? UUID(), name: "Onion", quantity: 0.5, unit: UnitVolume.tablespoons),
        ]),
        Recipe(id: UUID(uuidString: "954DA6BC-77DB-4F0F-A8F8-EC7C83437BCF") ?? UUID(), name: "Recipe C", mealCount: 1, ingredients: [
            Ingredient(id: UUID(uuidString: "5F002DC3-BA06-49C3-B48F-E056BF4D80FD") ?? UUID(), name: "Floor", quantity: 300, unit: UnitVolume.centiliters),
            Ingredient(id: UUID(uuidString: "ADF96216-27B5-42FF-9956-0546493F256C") ?? UUID(), name: "Egg", quantity: 1),
            Ingredient(id: UUID(uuidString: "9DB9A2AF-C40F-41B5-8BFD-E43A576517D4") ?? UUID(), name: "Milk", quantity: 50, unit: UnitVolume.centiliters),
            Ingredient(id: UUID(uuidString: "62D98ABF-2FFA-442A-A3BD-F0ECC7273D99") ?? UUID(), name: "Rhum", quantity: 4, unit: UnitVolume.tablespoons),
            Ingredient(id: UUID(uuidString: "16C56BC4-963A-4D1F-B833-63182B7848CA") ?? UUID(), name: "Vanilla extract", quantity: 0.5, unit: UnitVolume.teaspoons),
        ]),
        Recipe(id: UUID(uuidString: "B481E173-B910-476B-B557-076A0F99C4FA") ?? UUID(), name: "Recipe D", mealCount: 1, ingredients: []),
        Recipe(id: UUID(uuidString: "514577F9-CD35-4F71-A148-0081CA1B0CCB") ?? UUID(), name: "Recipe F", mealCount: 1, ingredients: []),
        Recipe(id: UUID(uuidString: "8FA33D27-3F03-48CC-95C6-DE26FACEA6C9") ?? UUID(), name: "Recipe E", mealCount: 1, ingredients: []),
    ]
}

extension Dictionary where Key == MealTime, Value == Recipe? {
    static let test: Self = .init(uniqueKeysWithValues: MealTime.allCases.map {
        switch $0 {
        case .sundayDinner: return ($0, [Recipe].test[0])
        case .mondayLunch: return ($0, [Recipe].test[0])
        case .mondayDinner: return ($0, [Recipe].test[1])
        case .tuesdayLunch: return ($0, [Recipe].test[1])
        case .tuesdayDinner: return ($0, [Recipe].test[2])
        case .wednesdayLunch: return ($0, [Recipe].test[3])
        case .wednesdayDinner: return ($0, [Recipe].test[4])
        case .saturdayLunch: return ($0, [Recipe].test[5])
        default: return ($0, nil)
        }
    })
}
