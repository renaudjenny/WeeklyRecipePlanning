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
}

struct RecipesEnvironment {
    var persistedRecipes: Effect<[Recipe], ApiError>
    var saveRecipes: ([Recipe]) -> Effect<Void, ApiError>
}

let recipesReducer = Reducer<RecipesState, RecipesAction, RecipesEnvironment> { state, action, environment in
    switch action {
    case .selectRecipe(_):
        print("select recipe")
        return .none
    case .addRecipe(_):
        print("add recipe")
        return .none

    case let .loadRecipes(.success(recipes)):
        print("receive recipes")
        return .none
    case .loadRecipes(.failure):
        print("Error when loading recipes")
        return .none
    case .saveRecipes:
        print("save recipes")
        return .none
    }
}

struct ApiError: Error, Equatable {}
