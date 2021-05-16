import ComposableArchitecture

struct RecipeListState: Equatable {
    var recipes: IdentifiedArrayOf<RecipeState>
}

enum RecipeListAction: Equatable {
    case addButtonTapped
    case delete(IndexSet)

    case load
    case loaded(Result<[Recipe], ApiError>)
    case save
    case saved(Result<Bool, ApiError>)

    case recipe(id: Recipe.ID, action: RecipeAction)
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
    Reducer { state, action, environment in
        struct SaveId: Hashable { }
        struct LoadId: Hashable { }
        struct SaveDebounceId: Hashable { }

        switch action {
        case .addButtonTapped:
            state.recipes.insert(RecipeState(recipe: .new(id: environment.uuid())), at: 0)
            return Effect(value: .save)
        case let .delete(indexSet):
            state.recipes.remove(atOffsets: indexSet)
            return Effect(value: .save)

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
        }
    }
)
