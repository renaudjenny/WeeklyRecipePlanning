import ComposableArchitecture
import SwiftUI

struct RecipeView: View {
    let store: Store<Recipe, RecipeAction>

    var body: some View {
        ScrollView {
            WithViewStore(store) { viewStore in
                TextField("Name", text: viewStore.binding(get: { $0.name }, send: RecipeAction.nameChanged))
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack {
                    Stepper("Meal count", value: viewStore.binding(get: { $0.mealCount }, send: RecipeAction.mealCountChanged), in: 0...99)
                    Text("\(viewStore.mealCount)")
                }
                .padding()

                Divider()

                HStack {
                    Text("Ingredients")
                    Button(action: { viewStore.send(.addIngredientButtonTapped) }) {
                        Image(systemName: "plus")
                    }
                }
                .padding()

                LazyVStack {
                    ForEachStore(store.scope(state: { $0.ingredients }, action: RecipeAction.ingredient(id:action:)), content: ingredientRow)
                        .onDelete { viewStore.send(.ingredientsDeleted($0)) }
                }
                .padding()
            }
        }
    }

    private func ingredientRow(store: Store<Ingredient, IngredientAction>) -> some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextField("Name", text: viewStore.binding(get: { $0.name }, send: IngredientAction.nameChanged))
                    .font(.title2)
                HStack {
                    HStack {
                        TextField("Quantity", text: viewStore.binding(get: { $0.quantity.text }, send: IngredientAction.quantityChanged))
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 100)
                        Text(viewStore.unit?.symbol ?? "-")
                        Spacer()
                    }
                    Picker("Change unit", selection: viewStore.binding(get: { $0.unit }, send: IngredientAction.unitChanged)) {
                        ForEach(RecipeUnit.allCases) { unit in
                            Text(unit.text).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
        }
    }
}

private extension Double {
    var text: String { numberFormatterDecimal.string(from: NSNumber(value: self)) ?? "Error" }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(store: Store(
            initialState: Recipe(
                id: UUID(),
                name: "Preview recipe",
                mealCount: 1,
                ingredients: [
                    Ingredient(id: UUID(), name: "Water", quantity: 100, unit: UnitVolume.centiliters),
                    Ingredient(id: UUID(), name: "Chocolate", quantity: 200, unit: UnitMass.grams),
                ]),
            reducer: recipeReducer,
            environment: RecipeEnvironment(uuid: { UUID() })
        ))
    }
}
