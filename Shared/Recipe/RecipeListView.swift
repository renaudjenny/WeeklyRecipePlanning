import SwiftUI
import ComposableArchitecture
import Combine

struct RecipeListView: View {
    let store: Store<RecipeListState, RecipeListAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEachStore(store.scope(state: { $0.recipes }, action: RecipeListAction.recipe(id:action:)), content: RecipeRowView.init)
                        .onDelete { viewStore.send(.delete($0)) }
                }
                .navigationTitle("Recipes")
                .toolbar {
                    ToolbarItem(placement: addRecipeButtonPlacement) {
                        addNewRecipeButton
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

    private var addNewRecipeButton: some View {
        WithViewStore(store) { viewStore in
            NavigationLink(
                destination: IfLetStore(store.scope(
                    state: \.newRecipe,
                    action: RecipeListAction.newRecipe
                ), then: RecipeView.init),
                isActive: viewStore.binding(
                    get: \.isNavigationToNewRecipeActive,
                    send: RecipeListAction.setNavigationToNewRecipe
                ),
                label: { Image(systemName: "plus") }
            )
        }
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
