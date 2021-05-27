import ComposableArchitecture

struct RecipeListState: Equatable {
    var recipes: IdentifiedArrayOf<RecipeState>
    var newRecipe: RecipeState?
    var isNavigationToNewRecipeActive: Bool { newRecipe != nil }
}

enum RecipeListAction: Equatable {
    case delete(IndexSet)
    case setNavigationToNewRecipe(isActive: Bool)

    case load
    case loaded(Result<[Recipe], ApiError>)
    case save
    case saved(Result<Bool, ApiError>)

    case recipe(id: Recipe.ID, action: RecipeAction)
    case newRecipe(RecipeAction)
}

struct RecipeListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var load: Effect<[Recipe], ApiError>
    var save: ([Recipe]) -> Effect<Bool, ApiError>
    var uuid: () -> UUID
}

let recipeListReducer = Reducer<RecipeListState, RecipeListAction, RecipeListEnvironment>.combine(
    recipeReducer.forEach(
        state: \.recipes,
        action: /RecipeListAction.recipe(id:action:),
        environment: { RecipeEnvironment(uuid: $0.uuid) }
    ),
    recipeReducer
        .optional()
        .pullback(
            state: \.newRecipe,
            action: /RecipeListAction.newRecipe,
            environment: { RecipeEnvironment(uuid: $0.uuid) }
        ),
    Reducer { state, action, environment in
        struct SaveId: Hashable { }
        struct LoadId: Hashable { }
        struct SaveDebounceId: Hashable { }

        switch action {
        case let .delete(indexSet):
            state.recipes.remove(atOffsets: indexSet)
            return Effect(value: .save)
        case .setNavigationToNewRecipe(isActive: true):
            let newRecipe = RecipeState(recipe: .new(id: environment.uuid()))
            state.newRecipe = newRecipe
            state.recipes.insert(newRecipe, at: 0)
            return .none
        case .setNavigationToNewRecipe(isActive: false):
            state.newRecipe = nil
            return .none

        case .load:
            return environment.load
                .catchToEffect()
                .map(RecipeListAction.loaded)
                .cancellable(id: LoadId())
        case let .loaded(.success(recipes)):
            state.recipes = IdentifiedArrayOf(recipes.map(RecipeState.init))
            return .cancel(id: LoadId())
        case .loaded(.failure):
            print("Error when loading recipes")
            return .cancel(id: LoadId())

        case .save:
            return environment.save(state.recipes.map(\.recipe))
                .catchToEffect()
                .map(RecipeListAction.saved)
                .cancellable(id: SaveId())
        case let .saved(.failure(error)):
            print("Error when saving recipes: \(error)")
            return .cancel(id: SaveId())
        case .saved(.success):
            return .cancel(id: SaveId())

        case .recipe:
            return Effect(value: .save)
                .debounce(id: SaveDebounceId(), for: .seconds(1), scheduler: environment.mainQueue)
                .eraseToEffect()
        case .newRecipe:
//            return Effect(value: .save)
//                .debounce(id: SaveDebounceId(), for: .seconds(1), scheduler: environment.mainQueue)
//                .eraseToEffect()
            return .none
        }
    }
)
