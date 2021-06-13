import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    let store: Store<WeekState, WeekAction>

    struct ViewState: Equatable {
        var mealTimeFilledCount: Int
    }

    var body: some View {
        WithViewStore(store.scope(state: \.view)) { viewStore in
            VStack {
                ProgressView(
                    "Planning completion \(viewStore.mealTimeFilledCount)/\(MealTime.allCases.count)",
                    value: Double(viewStore.mealTimeFilledCount),
                    total: Double(MealTime.allCases.count)
                )
                .padding()

                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEachStore(store.scope(
                            state: \.mealTimes,
                            action: WeekAction.mealTime(id:action:)
                        ), content: MealTimeView.init)
                    }
                    .padding()
                }
            }
        }
    }
}

private extension WeekState {
    var view: WeekView.ViewState {
        WeekView.ViewState(
            mealTimeFilledCount: mealTimeRecipes.values
                .compactMap { $0 }
                .count
        )
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(store: Store(
            initialState: WeekState(
                recipes: .embedded,
                mealTimeRecipes: mealTimeRecipes,
                mealTimes: WeekState.mealTimes(
                    recipes: .embedded,
                    mealTimeRecipes: mealTimeRecipes
                )),
            reducer: weekReducer,
            environment: WeekEnvironment()
        ))
    }

    private static let mealTimeRecipes: [MealTime: Recipe?] = .init(
        uniqueKeysWithValues: MealTime.allCases.map {
            switch $0 {
            case .sundayDinner: return ($0, [Recipe].embedded.first)
            case .mondayLunch: return ($0, [Recipe].embedded.first)
            case .wednesdayDinner: return ($0, [Recipe].embedded.last)
            default: return ($0, nil)
            }
        }
    )
}
