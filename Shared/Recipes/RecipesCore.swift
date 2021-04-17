import ComposableArchitecture

struct RecipesState: Equatable {
    var recipes: [Recipe] = .embedded
}

enum RecipesAction: Equatable {
    case addRecipe(Recipe)

    case load
    case loaded(Result<[Recipe], ApiError>)
    case save
    case saved(Result<Bool, ApiError>)
}

struct RecipesEnvironment {
    var load: () -> Effect<[Recipe], ApiError>
    var save: ([Recipe]) -> Effect<Bool, ApiError>
}

let recipesReducer = Reducer<RecipesState, RecipesAction, RecipesEnvironment> { state, action, environment in
    struct SaveId: Hashable { }
    struct LoadId: Hashable { }

    switch action {
    case let .addRecipe(recipe):
        state.recipes += [recipe]
        return Effect(value: .save)

    case .load:
        return environment.load()
            .catchToEffect()
            .map(RecipesAction.loaded)
            .cancellable(id: LoadId())
    case let .loaded(.success(recipes)):
        state.recipes = recipes
        return .cancel(id: LoadId())
    case .loaded(.failure):
        print("Error when loading recipes")
        return .cancel(id: LoadId())

    case .save:
        return environment.save(state.recipes)
            .catchToEffect()
            .map(RecipesAction.saved)
            .cancellable(id: SaveId())
    case let .saved(.failure(error)):
        print("Error when saving recipes: \(error)")
        return .cancel(id: SaveId())
    case .saved(.success):
        return .cancel(id: SaveId())
    }
}

struct ApiError: Error, Equatable {}
