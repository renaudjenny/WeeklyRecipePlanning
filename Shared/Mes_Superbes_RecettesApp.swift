import Combine
import ComposableArchitecture
import CoreData
import SwiftUI

@main
struct Mes_Superbes_RecettesApp: App {
    let store: Store<AppState, AppAction> = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
//            loadRecipes: { .mock(value: .embedded) },
//            saveRecipes: { _ in .mock(value: true) },
            loadRecipes: loadRecipesFromUserDefault,
            saveRecipes: saveRecipesToUserDefault,
            uuid: UUID.init
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }

    // TODO: improve this code and perhaps rely on something else than UserDefaults to save the recipes
    private static let persistedRecipesKey = "Recipes"
    static var loadRecipesFromUserDefault: Effect<[Recipe], ApiError> {
        return Future<[Recipe], ApiError> { promise in
            do {
                guard let data = UserDefaults.standard.data(forKey: Mes_Superbes_RecettesApp.persistedRecipesKey)
                else {
                    promise(.success([Recipe].embedded))
                    return
                }
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                promise(.success(recipes))
            } catch {
                promise(.failure(ApiError()))
            }
        }
        .eraseToEffect()
    }

    static func saveRecipesToUserDefault(recipes: [Recipe]) -> Effect<Bool, ApiError> {
        return Future<Bool, ApiError> { promise in
            do {
                let data = try JSONEncoder().encode(recipes)
                UserDefaults.standard.setValue(data, forKey: Mes_Superbes_RecettesApp.persistedRecipesKey)

                promise(.success(true))
            } catch {
                promise(.failure(ApiError()))
            }
        }
        .eraseToEffect()
    }
}
