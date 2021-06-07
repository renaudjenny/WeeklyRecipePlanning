import ComposableArchitecture
import SwiftUI

struct IngredientRow: View {
    let store: Store<IngredientState, IngredientAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Section {
                TextField(
                    "Name",
                    text: viewStore.binding(get: { $0.name }, send: IngredientAction.nameChanged)
                )
                .font(.title2)

                HStack {
                    TextField(
                        "Quantity",
                        text: viewStore.binding(
                            get: { $0.quantity.text },
                            send: IngredientAction.quantityChanged
                        )
                    )
                    .scaledToFit()
                    //.keyboardType(.decimalPad)

                    Divider()
                    Text(viewStore.unit?.symbol ?? "-")
                    Spacer()
                    Divider()
                    Button { viewStore.send(.unitButtonTapped, animation: .default) } label: {
                        Text(
                            viewStore.isUnitInEditionMode
                                ? "Close"
                                : "Edit unit"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if viewStore.isUnitInEditionMode {
                    Picker(
                        "Unit",
                        selection: viewStore.binding(
                            get: \.unit,
                            send: IngredientAction.unitChanged
                        )
                    ) {
                        ForEach(RecipeUnit.allCases) { unit in
                            Text(unit.text).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(pickerStyle)
                }
            }
        }
    }

    private var pickerStyle: some PickerStyle {
        #if os(iOS)
        return WheelPickerStyle()
        #else
        return DefaultPickerStyle()
        #endif
    }
}

struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            IngredientRow(store: Store(
                initialState: IngredientState(ingredient: Ingredient(
                    id: UUID(),
                    name: "Cream",
                    quantity: 50,
                    unit: UnitVolume.centiliters
                )),
                reducer: ingredientReducer,
                environment: IngredientEnvironment()
            ))
        }
    }
}

private extension Double {
    var text: String { numberFormatterDecimal.string(from: NSNumber(value: self)) ?? "Error" }
}
