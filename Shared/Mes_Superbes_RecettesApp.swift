import ComposableArchitecture
import SwiftUI

@main
struct Mes_Superbes_RecettesApp: App {
    let persistenceController = PersistenceController.preview
    let store: Store<RecipesState, RecipesAction> = Store(
        initialState: RecipesState(),
        reducer: recipesReducer,
        environment: .mock
    )

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
