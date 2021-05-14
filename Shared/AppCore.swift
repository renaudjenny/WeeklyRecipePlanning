import ComposableArchitecture

struct AppState: Equatable {
    var recipeList = RecipeListState(recipes: []) {
        didSet { week.allRecipes = recipeList.recipes.map(\.recipe) }
    }
    var week = WeekState(allRecipes: [], recipes: [])
}

enum AppAction: Equatable {
    case recipeList(RecipeListAction)
    case week(WeekAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var loadRecipes: Effect<[Recipe], ApiError>
    var saveRecipes: ([Recipe]) -> Effect<Bool, ApiError>
    var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    recipeListReducer.pullback(
        state: \.recipeList,
        action: /AppAction.recipeList,
        environment: { RecipeListEnvironment(
            mainQueue: $0.mainQueue,
            load: $0.loadRecipes,
            save: $0.saveRecipes,
            uuid: $0.uuid
        ) }
    ),
    weekReducer.pullback(
        state: \.week,
        action: /AppAction.week,
        environment: { _ in WeekEnvironment() }
    )
)
