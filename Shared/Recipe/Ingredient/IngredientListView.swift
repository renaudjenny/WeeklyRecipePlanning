import ComposableArchitecture
import SwiftUI

struct IngredientListView: View {
    let store: Store<IngredientListState, IngredientListAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Section(header: Text("Ingredients")) {
                Button(action: { viewStore.send(.addButtonTapped, animation: .default) }) {
                    Label("New ingredient", systemImage: "plus")
                }
            }
            ForEachStore(store.scope(state: { $0.ingredients }, action: IngredientListAction.ingredient(id:action:)), content: IngredientRow.init)
                .onDelete { viewStore.send(.delete($0), animation: .default) }
        }
    }
}
