import ComposableArchitecture
import SwiftUI

struct IngredientListView: View {
    let store: Store<IngredientListState, IngredientListAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ForEachStore(store.scope(state: { $0.ingredients }, action: IngredientListAction.ingredient(id:action:)), content: IngredientRow.init)
        }
    }
}
