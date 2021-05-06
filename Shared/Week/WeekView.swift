import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    let store: Store<WeekState, WeekAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Text("Number of different recipes: \(viewStore.week.recipes.count)")
                ProgressView(
                    "Planning completion",
                    value: Double(viewStore.mealTimeFilledCount),
                    total: Double(MealTime.allCases.count)
                )
                .padding()
                LazyVStack {
                    ForEach(MealTime.allCases, content: MealTimeView.init)
                }
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(store: Store(
            initialState: WeekState(week: Week(recipes: .embedded)),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }
}
