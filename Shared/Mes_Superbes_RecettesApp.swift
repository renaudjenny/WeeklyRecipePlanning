import SwiftUI

@main
struct Mes_Superbes_RecettesApp: App {
    let persistenceController = PersistenceController.preview

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
