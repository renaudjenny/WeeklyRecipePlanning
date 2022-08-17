import Foundation

extension Array where Element == Recipe {
    static let embedded: Self = [
        Recipe(
            id: UUID(uuidString: "B3EBE9FB-6B5C-44B0-AA64-C8AB23480493") ?? UUID(),
            name: "Pâtes aux poireaux",
            mealCount: 2,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "FB7CCCB8-71A5-4629-B691-5B517A74D69F") ?? UUID(),
                    name: "Leek",
                    quantity: 3
                ),
                Ingredient(
                    id: UUID(uuidString: "16E95A65-998B-4A49-9ADA-BFA4D232C592") ?? UUID(),
                    name: "Pasta",
                    quantity: 500,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "1B57A1D5-8734-44D0-9831-ACB7A7BC39CB") ?? UUID(),
                    name: "Cheddar",
                    quantity: 50,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "68F6D7B0-A148-4C70-8C33-981858EC648E") ?? UUID(),
                    name: "Red Leicester",
                    quantity: 50,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "B40E786D-D38B-4C9D-855D-F00B7278974C") ?? UUID(),
                    name: "Wine",
                    quantity: 5,
                    unit: UnitVolume.centiliters
                ),
                Ingredient(
                    id: UUID(uuidString: "ABC7F3A7-6A62-4B41-A639-953703CCB82E") ?? UUID(),
                    name: "Cream",
                    quantity: 25,
                    unit: UnitVolume.centiliters
                ),
                Ingredient(
                    id: UUID(uuidString: "3FBA334B-37DD-4B41-AE5D-83CEEC270BF6") ?? UUID(),
                    name: "Corn flour",
                    quantity: 1,
                    unit: UnitVolume.tablespoons
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "6B950EE7-ECB1-406A-975E-CA6ADDB70CD9") ?? UUID(),
            name: "Pâtes aux champignons",
            mealCount: 2,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "261AE567-6BC0-4AEF-8FE1-F059220822CF") ?? UUID(),
                    name: "Mushrooms",
                    quantity: 100,
                    unit: UnitMass.grams),
                Ingredient(
                    id: UUID(uuidString: "2571E661-731A-41F8-8A5A-B474DB8DFA67") ?? UUID(),
                    name: "Pasta",
                    quantity: 500,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "4A11F14F-64CF-4497-9450-22E9F0721D41") ?? UUID(),
                    name: "Cheddar",
                    quantity: 50,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "9D65F21B-55D5-407B-8C06-C9176DE74A5E") ?? UUID(),
                    name: "Red Leicester",
                    quantity: 50,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "DAA1E080-8739-452F-AFD4-995FB2D6677E") ?? UUID(),
                    name: "Wine",
                    quantity: 5,
                    unit: UnitVolume.centiliters
                ),
                Ingredient(
                    id: UUID(uuidString: "A7D1A904-8AFC-4274-AB07-42A1D0E77F55") ?? UUID(),
                    name: "Cream",
                    quantity: 25,
                    unit: UnitVolume.centiliters
                ),
                Ingredient(
                    id: UUID(uuidString: "DC471048-6C92-4A95-982A-C25A5FA9F1C5") ?? UUID(),
                    name: "Corn flour",
                    quantity: 1,
                    unit: UnitVolume.tablespoons
                ),
                Ingredient(
                    id: UUID(uuidString: "F6691519-FE51-4264-8628-D2D79F058719") ?? UUID(),
                    name: "Onion",
                    quantity: 0.5,
                    unit: UnitVolume.tablespoons
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "954DA6BC-77DB-4F0F-A8F8-EC7C83437BCF") ?? UUID(),
            name: "Crêpes façon Renaud",
            mealCount: 1,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "5F002DC3-BA06-49C3-B48F-E056BF4D80FD") ?? UUID(),
                    name: "Floor",
                    quantity: 300,
                    unit: UnitVolume.centiliters
                ),
                Ingredient(
                    id: UUID(uuidString: "ADF96216-27B5-42FF-9956-0546493F256C") ?? UUID(),
                    name: "Egg",
                    quantity: 1
                ),
                Ingredient(
                    id: UUID(uuidString: "9DB9A2AF-C40F-41B5-8BFD-E43A576517D4") ?? UUID(),
                    name: "Milk",
                    quantity: 50,
                    unit: UnitVolume.centiliters
                ),
                Ingredient(
                    id: UUID(uuidString: "62D98ABF-2FFA-442A-A3BD-F0ECC7273D99") ?? UUID(),
                    name: "Rhum",
                    quantity: 4,
                    unit: UnitVolume.tablespoons
                ),
                Ingredient(
                    id: UUID(uuidString: "16C56BC4-963A-4D1F-B833-63182B7848CA") ?? UUID(),
                    name: "Vanilla extract",
                    quantity: 0.5,
                    unit: UnitVolume.teaspoons
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "AEBD134B-443E-494F-BD1C-B85E221617A2") ?? UUID(),
            name: "Bread and cheese",
            mealCount: 1,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "B5F6F05E-4B82-46CB-80A9-1EB0A0202039") ?? UUID(),
                    name: "Bread",
                    quantity: 400,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "44C25072-9BC8-4E28-A74D-8E19CE6D64FE") ?? UUID(),
                    name: "Cheese",
                    quantity: 200,
                    unit: UnitMass.grams
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "05B34E8C-10F1-4E96-BCA6-E74559509D17") ?? UUID(),
            name: "Meatballs with Rice and Courgettes",
            mealCount: 2,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "07A649E1-8A81-408F-A7BA-0DF4A9A63371") ?? UUID(),
                    name: "Meatball",
                    quantity: 8
                ),
                Ingredient(
                    id: UUID(uuidString: "B5AD115B-A233-4636-AC37-EAEE20BF43FD") ?? UUID(),
                    name: "Rice",
                    quantity: 300,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "63F5B07E-505C-40E8-8225-9C98B9A23BFA") ?? UUID(),
                    name: "Courgettes",
                    quantity: 200,
                    unit: UnitMass.grams
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "00E7C592-1F7B-4501-926C-C1F7E4E62609") ?? UUID(),
            name: "Olivade",
            mealCount: 2,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "266916A5-977A-4590-978F-D5AA1195DC51") ?? UUID(),
                    name: "Olive",
                    quantity: 150,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "08EF8945-1E87-4337-B985-12E851A3A3AA") ?? UUID(),
                    name: "Garlic clove",
                    quantity: 1
                ),
                Ingredient(
                    id: UUID(uuidString: "7EB07C98-41D6-4035-92E8-5DE79F483A4B") ?? UUID(),
                    name: "Lemon juice",
                    quantity: 1,
                    unit: UnitVolume.teaspoons
                ),
                Ingredient(
                    id: UUID(uuidString: "294D0B98-7127-4AE0-ADF5-2921537493F9") ?? UUID(),
                    name: "Olive oil",
                    quantity: 2,
                    unit: UnitVolume.tablespoons
                ),
                Ingredient(
                    id: UUID(uuidString: "FACA71DB-BC64-4979-A277-09F42ECDC2EC") ?? UUID(),
                    name: "Pepper",
                    quantity: 1
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "4E9C834D-3B3C-42EC-A1A2-B5618B603668") ?? UUID(),
            name: "Mixed Salad",
            mealCount: 2,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "0F722F8B-1549-424B-92E1-CECB1E481EC7") ?? UUID(),
                    name: "Rice (before cooking and cooling)",
                    quantity: 150,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "3F179396-654C-4A48-8ACF-2E79852337D6") ?? UUID(),
                    name: "Melon",
                    quantity: 1
                ),
                Ingredient(
                    id: UUID(uuidString: "44C25072-9BC8-4E28-A74D-8E19CE6D64FE") ?? UUID(),
                    name: "Cheese",
                    quantity: 200,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "9EACF95D-88BA-4A2C-BF8A-F26FA79CB812") ?? UUID(),
                    name: "Cherry tomatoes",
                    quantity: 200,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "59EA520B-84A3-4D38-A77B-3B3D70AB7A09") ?? UUID(),
                    name: "Carrots",
                    quantity: 100,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "864F0BC3-AA79-460E-A88B-D79BF19EE446") ?? UUID(),
                    name: "Salad Dressing",
                    quantity: 200,
                    unit: UnitMass.grams
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "BF7472E4-5C35-4767-A08D-F53C3C0D992D") ?? UUID(),
            name: "Vegetable Quiche",
            mealCount: 2,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "8A1C8D87-1450-42FF-ABAF-1B895A331E2B") ?? UUID(),
                    name: "Feta cheese",
                    quantity: 200,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "63F5B07E-505C-40E8-8225-9C98B9A23BFA") ?? UUID(),
                    name: "Courgettes",
                    quantity: 200,
                    unit: UnitMass.grams
                ),
                Ingredient(
                    id: UUID(uuidString: "FACA71DB-BC64-4979-A277-09F42ECDC2EC") ?? UUID(),
                    name: "Pepper",
                    quantity: 1
                ),
                Ingredient(
                    id: UUID(uuidString: "ADF96216-27B5-42FF-9956-0546493F256C") ?? UUID(),
                    name: "Egg",
                    quantity: 3
                ),
                Ingredient(
                    id: UUID(uuidString: "1060345B-33E8-4A2F-B9AA-4D1B5ADC7F78") ?? UUID(),
                    name: "Puff pastry dough",
                    quantity: 1
                ),
            ]
        ),
        Recipe(
            id: UUID(uuidString: "94317791-0E44-448D-A85C-6008B9AE4423") ?? UUID(),
            name: "Frozen pizza",
            mealCount: 1,
            ingredients: [
                Ingredient(
                    id: UUID(uuidString: "BDDD76CF-943F-44D2-A56E-5EAC140669E9") ?? UUID(),
                    name: "Frozen Pizza",
                    quantity: 2
                ),
            ]
        ),
    ]
}
