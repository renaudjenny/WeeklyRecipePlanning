import ComposableArchitecture

struct AppState: Equatable {
    var recipeList = RecipeListState()
}

enum AppAction: Equatable {
    case recipeList(RecipeListAction)
}

struct AppEnvironment {
    var loadRecipes: Effect<[Recipe], ApiError>
    var saveRecipes: ([Recipe]) -> Effect<Bool, ApiError>
    var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    recipeListReducer.pullback(
        state: \.recipeList,
        action: /AppAction.recipeList,
        environment: { RecipeListEnvironment(
            load: $0.loadRecipes,
            save: $0.saveRecipes,
            uuid: $0.uuid
        ) }
    )
)
