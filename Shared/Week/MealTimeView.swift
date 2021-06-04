import ComposableArchitecture
import SwiftUI

struct MealTimeView: View {
    let store: Store<MealTimeState, MealTimeAction>

    var body: some View {
        // TODO: use a scoped ViewStore here, there is stuff in the state this view doesn't care
        WithViewStore(store) { viewStore in
            Button { viewStore.send(.mealTimeTapped) } label: {
                HStack {
                    ZStack {
                        if viewStore.recipe != nil {
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
                        Text(viewStore.mealTime.name)
                            .font(.headline)
                        Text(viewStore.recipe?.name ?? "-")
                            .font(.subheadline)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: viewStore.binding(
                get: { $0.recipeSelector != nil },
                send: .dismissRecipeSelector
            )) {
                IfLetStore(store.scope(
                    state: \.recipeSelector,
                    action: MealTimeAction.recipeSelector
                ), then: RecipeSelectorView.init)
            }
        }
    }
}

struct MealTimeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LazyVStack(alignment: .leading) {
                makeMealTimeView(for: .sundayDinner)
                makeMealTimeView(for: .mondayLunch)
                makeMealTimeView(for: .mondayLunch)
                makeMealTimeView(for: .mondayDinner)
                makeMealTimeView(for: .tuesdayLunch)
                makeMealTimeView(for: .tuesdayDinner)
            }
            LazyVStack(alignment: .leading) {
                makeMealTimeView(for: .sundayDinner)
                makeMealTimeView(for: .mondayLunch)
                makeMealTimeView(for: .mondayLunch)
                makeMealTimeView(for: .mondayDinner)
                makeMealTimeView(for: .tuesdayLunch)
                makeMealTimeView(for: .tuesdayDinner)
            }
            .preferredColorScheme(.dark)
        }
        .padding()
    }

    private static func makeMealTimeView(for mealTime: MealTime) -> some View {
        MealTimeView(store: Store(
            initialState: MealTimeState(
                mealTime: mealTime,
                recipes: .embedded,
                mealTimeRecipes: mealTimeRecipes
            ),
            reducer: mealTimeReducer,
            environment: MealTimeEnvironment()
        ))
    }

    private static let mealTimeRecipes: [MealTime: Recipe?] = .init(uniqueKeysWithValues: MealTime.allCases.map {
        switch $0 {
        case .sundayDinner: return ($0, [Recipe].embedded.first)
        case .mondayLunch: return ($0, [Recipe].embedded.first)
        case .wednesdayDinner: return ($0, [Recipe].embedded.last)
        default: return ($0, nil)
        }
    })
}
