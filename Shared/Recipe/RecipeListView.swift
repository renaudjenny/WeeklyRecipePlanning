import SwiftUI
import ComposableArchitecture
import Combine

struct RecipeListView: View {
    let store: Store<RecipeListState, RecipeListAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.recipes) { recipe in
                        NavigationLink(
                            destination: IfLetStore(
                                store.scope(
                                    state: \.selection?.value,
                                    action: RecipeListAction.recipe
                                ),
                                then: RecipeView.init(store:)
                            ),
                            tag: recipe.id,
                            selection: viewStore.binding(
                                get: \.selection?.id,
                                send: RecipeListAction.setNavigation(selection:)
                            )
                        ) {
                            RecipeRowView(recipe: recipe.recipe)
                        }
                    }
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
            HStack {
                Button {
                    viewStore.send(.addNewRecipe)
                } label: { Image(systemName: "plus") }
            }
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
