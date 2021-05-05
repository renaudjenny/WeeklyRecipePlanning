import SwiftUI

struct MealTimeView: View {
    let mealTime: MealTime

    var body: some View {
        Text(mealTime.name)
    }
}
