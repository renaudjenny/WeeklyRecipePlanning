import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    let store: Store<WeekState, WeekAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ProgressView(
                    "Planning completion \(viewStore.mealTimeFilledCount)/\(MealTime.allCases.count)",
                    value: Double(viewStore.mealTimeFilledCount),
                    total: Double(MealTime.allCases.count)
                )
                .padding()

                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewStore.mealTimes) { mealTimeRecipe in
                            MealTimeView(mealTimeRecipe: mealTimeRecipe)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(store: Store(
            initialState: WeekState(allRecipes: .embedded, mealTimeRecipes: .init(uniqueKeysWithValues: MealTime.allCases.map {
                switch $0 {
                case .sundayDinner: return ($0, [Recipe].embedded.first)
                case .mondayLunch: return ($0, [Recipe].embedded.first)
                case .wednesdayDinner: return ($0, [Recipe].embedded.last)
                default: return ($0, nil)
                }
            })),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }
}
