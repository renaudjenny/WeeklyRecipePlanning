import ComposableArchitecture

struct RecipesState: Equatable {
    var recipes: IdentifiedArrayOf<Recipe> = .embedded
}

enum RecipesAction: Equatable {
    case addRecipeButtonTapped

    case load
    case loaded(Result<IdentifiedArrayOf<Recipe>, ApiError>)
    case save
    case saved(Result<Bool, ApiError>)

    case recipe(id: Recipe.ID, action: RecipeAction)
}

struct RecipesEnvironment {
    var load: () -> Effect<IdentifiedArrayOf<Recipe>, ApiError>
    var save: (IdentifiedArrayOf<Recipe>) -> Effect<Bool, ApiError>
    var uuid: () -> UUID
}

let recipesReducer = Reducer<RecipesState, RecipesAction, RecipesEnvironment>.combine(
    recipeReducer.forEach(
        state: \.recipes,
        action: /RecipesAction.recipe(id:action:),
        environment: { RecipeEnvironment(uuid: $0.uuid) }
    ),
    Reducer { state, action, environment in
        struct SaveId: Hashable { }
        struct LoadId: Hashable { }

        switch action {
        case .addRecipeButtonTapped:
            state.recipes.insert(.new(id: environment.uuid()), at: 0)
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

        case .recipe:
            return .none
        }
    }
)

struct ApiError: Error, Equatable {}
