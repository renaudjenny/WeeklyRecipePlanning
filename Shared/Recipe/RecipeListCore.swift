import ComposableArchitecture

struct RecipeListState: Equatable {
    var recipes: IdentifiedArrayOf<RecipeState>
    var selection: Identified<Recipe.ID, RecipeState>?
}

enum RecipeListAction: Equatable {
    case addNewRecipe
    case setNavigation(selection: Recipe.ID?)
    case delete(IndexSet)

    case load
    case loaded(Result<[Recipe], ApiError>)
    case save
    case saved(Result<Bool, ApiError>)

    case recipe(RecipeAction)
}

struct RecipeListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var load: Effect<[Recipe], ApiError>
    var save: ([Recipe]) -> Effect<Bool, ApiError>
    var uuid: () -> UUID
}

let recipeListReducer = Reducer<RecipeListState, RecipeListAction, RecipeListEnvironment>.combine(
    recipeReducer
        .pullback(
            state: \Identified.value,
            action: .self,
            environment: { $0 }
        )
        .optional()
        .pullback(
            state: \.selection,
            action: /RecipeListAction.recipe,
            environment: { RecipeEnvironment(uuid: $0.uuid) }
        ),
    Reducer { state, action, environment in
        struct SaveId: Hashable { }
        struct LoadId: Hashable { }
        struct SaveDebounceId: Hashable { }

        switch action {
        case .addNewRecipe:
            let newRecipe = RecipeState(recipe: .new(id: environment.uuid()))
            state.recipes.insert(newRecipe, at: 0)
            return Effect(value: .setNavigation(selection: newRecipe.id))
        case let .setNavigation(selection: .some(id)):
            guard let recipe = state.recipes[id: id]
            else { return .none }
            state.selection = Identified(recipe, id: \.id)
            return .none
        case .setNavigation(selection: .none):
            state.selection = nil
            return .none
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
