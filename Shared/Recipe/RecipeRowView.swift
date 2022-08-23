import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.title2)
                .padding(.top)
            HStack {
                Text("For ^[\(recipe.mealCount) \("meal")](inflect: true).")
                Text("^[\(recipe.ingredients.count) \("ingredient")](inflect: true)")
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
