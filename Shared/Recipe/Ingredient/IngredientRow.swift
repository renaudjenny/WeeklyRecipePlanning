import ComposableArchitecture
import SwiftUI

struct IngredientRow: View {
    let store: Store<IngredientState, IngredientAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Section {
                TextField("Name", text: viewStore.binding(get: { $0.name }, send: IngredientAction.nameChanged))
                    .font(.title2)
                HStack {
                    TextField("Quantity", text: viewStore.binding(get: { $0.quantity.text }, send: IngredientAction.quantityChanged))
                        .scaledToFit()
                    //                    .keyboardType(.decimalPad)
                    Text(viewStore.unit?.symbol ?? "-")
                    Spacer()
                    Button { } label: {
                        Text(
                            viewStore.isUnitInEditionMode
                            ? "Edit unit"
                            : "Close"
                        )
                    }
                    .onTapGesture { viewStore.send(.unitButtonTapped, animation: .default) }
                }

                if viewStore.isUnitInEditionMode {
                    Picker("Unit", selection: viewStore.binding(get: { $0.unit }, send: IngredientAction.unitChanged)) {
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

private extension Double {
    var text: String { numberFormatterDecimal.string(from: NSNumber(value: self)) ?? "Error" }
}
