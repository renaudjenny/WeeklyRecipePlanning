import SwiftUI
import ComposableArchitecture
import Combine

struct RecipeListView: View {
    let store: Store<RecipeListState, RecipeListAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0 })) { viewStore in
            List {
                ForEachStore(store.scope(state: { $0.recipes }, action: RecipeListAction.recipe(id:action:)), content: row)
                    .onDelete { viewStore.send(.delete($0)) }
            }
            .toolbar {
                ToolbarItem(placement: addRecipeButtonPlacement) {
                    Button { viewStore.send(.addButtonTapped) } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear { viewStore.send(.load) }
        }
    }

    private func row(store: Store<RecipeState, RecipeAction>) -> some View {
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

    private var addRecipeButtonPlacement: ToolbarItemPlacement {
        #if os(iOS)
        return ToolbarItemPlacement.navigationBarTrailing
        #else
        return ToolbarItemPlacement.automatic
        #endif
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(store: Store(
            initialState: RecipeListState(
                recipes: IdentifiedArrayOf([Recipe].embedded.map(RecipeState.init))
            ),
            reducer: recipeListReducer,
            environment: .mock
        ))
    }
}
