import SwiftUI
import ComposableArchitecture
import Combine

struct RecipesView: View {
    let store: Store<RecipesState, RecipesAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0 })) { viewStore in
            List {
                ForEachStore(store.scope(state: { $0.recipes }, action: RecipesAction.recipe(id:action:)), content: row)
                    .onDelete { viewStore.send(.deleteRecipes($0)) }
            }
        }
    }

    private func row(store: Store<Recipe, RecipeAction>) -> some View {
        WithViewStore(store) { viewStore in
            NavigationLink(
                destination: RecipeView(store: store),
                label: {
                    VStack(alignment: .leading) {
                        Text(viewStore.name)
                            .font(.title)
                            .padding(.top)
                        HStack {
                            Text("For \(viewStore.mealCount) \(viewStore.mealCount == 1 ? "meal" : "meals").")
                            Text("\(viewStore.ingredients.count) ingredients")
                                .italic()
                        }.padding(.bottom)
                    }
                })
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
        save: { _ in .mock(value: true) },
        uuid: { .zero }
    )
}

extension UUID {
    static let zero: Self = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}

extension Effect {
    static func mock(value: Output) -> Self {
        Just(value).mapError({ _ in ApiError() as! Failure }).eraseToEffect()
    }
}
