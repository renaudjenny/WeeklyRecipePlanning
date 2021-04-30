import Combine
import ComposableArchitecture
import CoreData
import SwiftUI

@main
struct Mes_Superbes_RecettesApp: App {
    let persistenceController = PersistenceController.shared
    let store: Store<RecipesState, RecipesAction> = Store(
        initialState: RecipesState(),
        reducer: recipesReducer,
        environment: RecipesEnvironment(
            //            load: { .mock(value: .embedded) },
            //            save: { _ in .mock(value: true) },
            load: { loadRecipesFromPersistenceController },
            save: saveRecipesToPersistenceController,
            uuid: UUID.init
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    static var loadRecipesFromPersistenceController: Effect<IdentifiedArrayOf<Recipe>, ApiError> {
        let persistenceController = PersistenceController.shared
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        return Future<IdentifiedArrayOf<Recipe>, ApiError> { promise in
            do {
                let items = try persistenceController.container.viewContext.fetch(request)
                let recipes = items.map(\.recipe)
                promise(.success(IdentifiedArrayOf(recipes)))
            } catch {
                promise(.failure(ApiError()))
            }
        }
        .eraseToEffect()
    }

    static func saveRecipesToPersistenceController(recipes: IdentifiedArrayOf<Recipe>) -> Effect<Bool, ApiError> {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext

        return Future<Bool, ApiError> { promise in
            do {
                try recipes.forEach { recipe in
                    let item = Item(context: context)
                    item.isSelected = false
                    item.serializedRecipe = try JSONEncoder().encode(recipe)
                    item.timestamp = Date()
                }

                try context.save()

                promise(.success(true))
            } catch {
                promise(.failure(ApiError()))
            }
        }
        .eraseToEffect()
    }
}
