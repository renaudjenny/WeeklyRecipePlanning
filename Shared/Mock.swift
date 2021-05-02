#if DEBUG
import Combine
import ComposableArchitecture
import Foundation

extension AppEnvironment {
    static let mock: Self = AppEnvironment(
        loadRecipes: { .mock(value: .embedded) },
        saveRecipes: { _ in .mock(value: true) },
        uuid: { .zero }
    )
}

extension RecipeListEnvironment {
    static let mock: Self = RecipeListEnvironment(
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
        Just(value).mapError({ _ in ApiError() as! Failure }).eraseToEffect()
    }
}

#endif
