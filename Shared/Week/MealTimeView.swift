import SwiftUI

struct MealTimeView: View {
    let mealTimeRecipe: MealTimeRecipe
    @State private var isRecipeDisplayed = false

    var body: some View {
        Button { isRecipeDisplayed.toggle() } label: {
            HStack {
                ZStack {
                    if mealTimeRecipe.recipe != nil {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 25, height: 25)
                            .padding(.horizontal)
                    }
                    Circle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                }
                VStack(alignment: .leading) {
                    Text(mealTimeRecipe.mealTime.name)
                        .font(.headline)
                    Text(mealTimeRecipe.recipe?.name ?? "-")
                        .font(.subheadline)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isRecipeDisplayed, content: {
            if let recipe = mealTimeRecipe.recipe {
                RecipeView(readOnlyRecipe: recipe)
            } else {
                Text("\(mealTimeRecipe.mealTime.name) has no recipe yet. Add more recipes in the week planning.")
            }
        })
    }
}

struct MealTimeView_Previews: PreviewProvider {
    private static let recipes = [Recipe].embedded

    static var previews: some View {
        Group {
            LazyVStack(alignment: .leading) {
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .sundayDinner, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayLunch, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayDinner, recipe: recipes[2]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayLunch, recipe: nil))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayDinner, recipe: nil))
            }
            LazyVStack(alignment: .leading) {
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .sundayDinner, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayLunch, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayDinner, recipe: recipes[2]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayLunch, recipe: nil))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayDinner, recipe: nil))
            }
            .preferredColorScheme(.dark)
        }
        .padding()
    }
}
