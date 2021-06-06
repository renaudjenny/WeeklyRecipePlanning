import ComposableArchitecture
import SwiftUI

struct MealTimeView: View {
    let store: Store<MealTimeState, MealTimeAction>

    struct ViewState: Equatable {
        var recipeName: String
        var mealTimeName: String
        var isSelected: Bool
        var isRecipeSelectorPresented: Bool
    }

    var body: some View {
        WithViewStore(store.scope(state: \.view)) { viewStore in
            Button { viewStore.send(.mealTimeTapped) } label: {
                HStack {
                    ZStack {
                        if viewStore.isSelected {
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
                        Text(viewStore.mealTimeName)
                            .font(.headline)
                        Text(viewStore.recipeName)
                            .font(.subheadline)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: viewStore.binding(
                get: \.isRecipeSelectorPresented,
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

private extension MealTimeState {
    var view: MealTimeView.ViewState {
        MealTimeView.ViewState(
            recipeName: recipe?.name ?? "-",
            mealTimeName: mealTime.name,
            isSelected: recipe != nil,
            isRecipeSelectorPresented: recipeSelector != nil
        )
    }
}

struct MealTimeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LazyVStack(alignment: .leading) {
                makeMealTimeView(for: .sundayDinner)
                makeMealTimeView(for: .mondayLunch)
                makeMealTimeView(for: .mondayDinner)
                makeMealTimeView(for: .tuesdayLunch)
                makeMealTimeView(for: .tuesdayDinner)
                makeMealTimeView(for: .wednesdayLunch)
            }
            LazyVStack(alignment: .leading) {
                makeMealTimeView(for: .sundayDinner)
                makeMealTimeView(for: .mondayLunch)
                makeMealTimeView(for: .mondayDinner)
                makeMealTimeView(for: .tuesdayLunch)
                makeMealTimeView(for: .tuesdayDinner)
                makeMealTimeView(for: .wednesdayLunch)
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
        case .wednesdayLunch: return ($0, [Recipe].embedded.last)
        default: return ($0, nil)
        }
    })
}
