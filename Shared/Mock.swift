#if DEBUG
import Combine
import ComposableArchitecture
import Foundation

extension AppEnvironment {
    static let mock: Self = AppEnvironment(
        mainQueue: .main,
        loadRecipes: .mock(value: .embedded),
        saveRecipes: { _ in .mock(value: true) },
        uuid: { .zero }
    )
}

extension RecipeListEnvironment {
    static let mock: Self = RecipeListEnvironment(
        mainQueue: AppEnvironment.mock.mainQueue,
        load: AppEnvironment.mock.loadRecipes,
        save: AppEnvironment.mock.saveRecipes,
        uuid: AppEnvironment.mock.uuid
    )
}

extension UUID {
    static let zero: Self = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}

extension Effect {
    static func mock(value: Output) -> Self {
        Future { promise in promise(.success(value)) }.eraseToEffect()
    }
}

#endif
