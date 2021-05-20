import SwiftUI
import ComposableArchitecture
import Combine

struct RecipeListView: View {
    let store: Store<RecipeListState, RecipeListAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0 })) { viewStore in
            NavigationView {
                List {
                    ForEachStore(store.scope(state: { $0.recipes }, action: RecipeListAction.recipe(id:action:)), content: RecipeRowView.init)
                        .onDelete { viewStore.send(.delete($0)) }
                }
                .navigationTitle("Recipes")
                .toolbar {
                    ToolbarItem(placement: addRecipeButtonPlacement) {
                        Button { viewStore.send(.addButtonTapped) } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .onAppear { viewStore.send(.load) }
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
