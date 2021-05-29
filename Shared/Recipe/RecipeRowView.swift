import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.title)
                .padding(.top)
            HStack {
                Text("For \(recipe.mealCount) \(recipe.mealCount == 1 ? "meal" : "meals").")
                Text("\(recipe.ingredients.count) \(recipe.ingredients.count == 1 ? "ingredient" : "ingredients")")
                    .italic()
            }.padding(.bottom)
        }
    }
}

struct RecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRowView(recipe: [Recipe].embedded.first!)
    }
}
