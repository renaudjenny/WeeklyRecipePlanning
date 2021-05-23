import ComposableArchitecture
import SwiftUI

struct MealTimeView: View {
    let mealTime: MealTime
    let store: Store<WeekState, WeekAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Button { viewStore.send(.selectMealTime(mealTime)) } label: {
                HStack {
                    ZStack {
                        if viewStore.mealTimeRecipes[mealTime] != nil {
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
                        Text(mealTime.name)
                            .font(.headline)
                        Text(viewStore.mealTimeRecipes[mealTime]??.name ?? "-")
                            .font(.subheadline)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(item: viewStore.binding(get: { $0.selectedMealTime }, send: .dismissMealTime), content: { _ in
                RecipeSelectorView(store: store)
            })
        }
    }
}

struct MealTimeView_Previews: PreviewProvider {
    private static let store: Store<WeekState, WeekAction> = Store(
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
    )

    static var previews: some View {
        Group {
            LazyVStack(alignment: .leading) {
                MealTimeView(mealTime: .sundayDinner, store: store)
                MealTimeView(mealTime: .mondayLunch, store: store)
                MealTimeView(mealTime: .mondayDinner, store: store)
                MealTimeView(mealTime: .tuesdayLunch, store: store)
                MealTimeView(mealTime: .tuesdayDinner, store: store)
            }
            LazyVStack(alignment: .leading) {
                MealTimeView(mealTime: .sundayDinner, store: store)
                MealTimeView(mealTime: .mondayLunch, store: store)
                MealTimeView(mealTime: .mondayDinner, store: store)
                MealTimeView(mealTime: .tuesdayLunch, store: store)
                MealTimeView(mealTime: .tuesdayDinner, store: store)
            }
            .preferredColorScheme(.dark)
        }
        .padding()
    }
}
