import ComposableArchitecture
import SwiftUI

@main
struct Mes_Superbes_RecettesApp: App {
    let persistenceController = PersistenceController.preview
    let store: Store<RecipesState, RecipesAction> = Store(
        initialState: RecipesState(),
        reducer: recipesReducer,
        environment: RecipesEnvironment(
            load: { .mock(value: .embedded) },
            save: { _ in .mock(value: true) },
            uuid: UUID.init
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
