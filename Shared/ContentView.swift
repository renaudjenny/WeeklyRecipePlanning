import ComposableArchitecture
import CoreData
import SwiftUI

struct ContentView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        TabView {
            RecipeListView(store: store.scope(state: { $0.recipeList }, action: AppAction.recipeList))
            .tabItem {
                Image(systemName: "text.book.closed")
                Text("Recipes")
            }
            WeekView(store: store.scope(state: { $0.week }, action: AppAction.week))
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Week")
                }
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
