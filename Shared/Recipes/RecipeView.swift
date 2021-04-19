import ComposableArchitecture
import SwiftUI

struct RecipeView: View {
    @Binding var recipe: Recipe

    var body: some View {
        VStack {
            TextField("Name", text: $recipe.name)
                .font(.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Stepper("Meal count", value: $recipe.mealCount, in: 0...99)
                Text("\(recipe.mealCount)")
            }
            .padding()

            Divider()

            HStack {
                Text("Ingredients")
                Button(action: { addIngredient(to: $recipe) }) {
                    Image(systemName: "plus")
                }
            }
            .padding()

            List {
                ForEach($recipe.ingredients, content: ingredientRow)
            }
        }
    }

    private func addIngredient(to recipe: Binding<Recipe>) {
        recipe.wrappedValue.ingredients.insert(Ingredient(name: "New ingredient", quantity: 1.25, unit: UnitVolume.centiliters), at: 0)
    }

    private func ingredientRow(index: Int, ingredient: Binding<Ingredient>) -> some View {
        VStack {
            TextField("Name", text: ingredient.name)
                .font(.title2)
            TextField("Quantity", text: ingredient.quantity.text)
            // TODO: Unit
        }
    }
}

extension Binding where Value == Double {
    var text: Binding<String> {
        .init(
            get: { numberFormatterDecimal.string(from: NSNumber(value: self.wrappedValue)) ?? "ERROR" },
            set: { self.wrappedValue = Double($0) ?? 0 }
        )
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: .constant([Recipe].embedded.first!))
    }
}
