import SwiftUI

struct MealTimeView: View {
    let mealTimeRecipe: MealTimeRecipe

    var body: some View {
        HStack {
            ZStack {
                if mealTimeRecipe.recipe != nil {
                    Circle()
                        .foregroundColor(.yellow)
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                }
                Circle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 2))
                    .frame(width: 25, height: 25)
                    .padding(.horizontal)
            }
            Text(mealTimeRecipe.mealTime.name)
        }
    }
}

struct MealTimeView_Previews: PreviewProvider {
    private static let recipes = [Recipe].embedded

    static var previews: some View {
        Group {
            VStack(alignment: .leading) {
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .sundayDiner, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayLunch, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayDiner, recipe: recipes[2]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayLunch, recipe: nil))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayDiner, recipe: nil))
            }
            VStack(alignment: .leading) {
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .sundayDiner, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayLunch, recipe: recipes[0]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .mondayDiner, recipe: recipes[2]))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayLunch, recipe: nil))
                MealTimeView(mealTimeRecipe: MealTimeRecipe(mealTime: .tuesdayDiner, recipe: nil))
            }
            .preferredColorScheme(.dark)
        }
    }
}
