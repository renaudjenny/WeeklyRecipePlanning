import ComposableArchitecture

struct RecipesState: Equatable {
    var recipes: [Recipe] = .embedded
    var selectedRecipes: [Recipe: Bool] = [:]
}

enum RecipesAction: Equatable {
    case selectRecipe(Recipe)
    case addRecipe(Recipe)

    case loadRecipes(Result<[Recipe], ApiError>)
    case saveRecipes
    case saved(Result<Bool, ApiError>)
}

struct RecipesEnvironment {
    var persistedRecipes: Effect<[Recipe], ApiError>
    var saveRecipes: ([Recipe]) -> Effect<Bool, ApiError>
}

let recipesReducer = Reducer<RecipesState, RecipesAction, RecipesEnvironment> { state, action, environment in
    struct SaveRecipesId: Hashable { }

    switch action {
    case .selectRecipe(_):
        print("select recipe")
        return .none
    case let .addRecipe(recipe):
        state.recipes += [recipe]
        return Effect(value: .saveRecipes)

    case let .loadRecipes(.success(recipes)):
        print("receive recipes")
        return .none
    case .loadRecipes(.failure):
        print("Error when loading recipes")
        return .none
    case .saveRecipes:
        return environment.saveRecipes(state.recipes)
            .catchToEffect()
            .map(RecipesAction.saved)
            .cancellable(id: SaveRecipesId())
    case let .saved(.failure(error)):
        print("Error when saving recipes: \(error)")
        return .cancel(id: SaveRecipesId())
    case .saved(.success):
        return .cancel(id: SaveRecipesId())
    }
}

struct ApiError: Error, Equatable {}
