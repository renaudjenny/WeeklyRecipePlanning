import SwiftUI
import ComposableArchitecture
import Combine

struct RecipesView: View {
    struct ViewState: Equatable {
        var recipes: [Recipe]
    }
    enum ViewAction: Equatable {
        case update(Recipe)
    }

    let store: Store<RecipesState, RecipesAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0.view }, action: RecipesAction.view)) { viewStore in
            List {
                ForEach(viewStore.recipes) {
                    row($0, viewStore: viewStore)
                }
            }
        }
    }

    private func row(_ recipe: Recipe, viewStore: ViewStore<ViewState, ViewAction>) -> some View {
        NavigationLink(
            destination: RecipeView(recipe: viewStore.binding(
                get: { $0.recipes.first! },
                send: ViewAction.update
            )),
            label: {
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.title)
                        .padding(.top)
                    HStack {
                        Text("For \(recipe.mealCount) \(recipe.mealCount == 1 ? "meal" : "meals").")
                        Text("\(recipe.ingredients.count) ingredients")
                            .italic()
                    }.padding(.bottom)
                }
            })
    }
}

private extension RecipesState {
    var view: RecipesView.ViewState {
        RecipesView.ViewState(recipes: recipes)
    }
}

private extension RecipesAction {
    static func view(localAction: RecipesView.ViewAction) -> Self {
        switch localAction {
        case let .update(recipe): return .update(recipe)
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView(store: Store(
            initialState: RecipesState(),
            reducer: recipesReducer,
            environment: .mock
        ))
    }
}

extension RecipesEnvironment {
    static let mock: Self = RecipesEnvironment(
        load: { .mock(value: .embedded) },
        save: { _ in .mock(value: true) }
    )
}

extension Effect {
    static func mock(value: Output) -> Self {
        Just(value).mapError({ _ in ApiError() as! Failure }).eraseToEffect()
    }
}
