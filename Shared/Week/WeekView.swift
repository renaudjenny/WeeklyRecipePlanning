import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    let store: Store<WeekState, WeekAction>

    var body: some View {
        LazyVStack {
            ForEach(MealTime.allCases, content: MealTimeView.init)
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
