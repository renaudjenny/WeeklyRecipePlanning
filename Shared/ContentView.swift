import ComposableArchitecture
import CoreData
import SwiftUI

struct ContentView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            RecipeListView(store: store.scope(state: { $0.recipeList }, action: AppAction.recipeList))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: .mock
        ))
    }
}
