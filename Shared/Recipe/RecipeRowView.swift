import SwiftUI
import ComposableArchitecture

struct RecipeRowView: View {
    let store: Store<RecipeState, RecipeAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationLink(
                destination: RecipeView(store: store),
                label: {
                    VStack(alignment: .leading) {
                        Text(viewStore.name)
                            .font(.title)
                            .padding(.top)
                        HStack {
                            Text("For \(viewStore.mealCount) \(viewStore.mealCount == 1 ? "meal" : "meals").")
                            Text("\(viewStore.ingredients.count) ingredients")
                                .italic()
                        }.padding(.bottom)
                    }
                })
        }
    }
}

struct RecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRowView(store: Store(
            initialState: RecipeState(recipe: [Recipe].embedded.first!),
            reducer: recipeReducer,
            environment: RecipeEnvironment(uuid: UUID.init)
        ))
    }
}
