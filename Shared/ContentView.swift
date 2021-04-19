import ComposableArchitecture
import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Item>

    let store: Store<RecipesState, RecipesAction>

    var body: some View {
        NavigationView {
            RecipesView(store: store)
        }
//        List {
//            ForEach(items, content: row)
//        }
//        .padding()
        // Keep that code for later, could be useful after learning CoreData
//        List {
//            ForEach(items) { item in
//                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//            }
//            .onDelete(perform: deleteItems)
//        }
//        .toolbar {
//            #if os(iOS)
//            EditButton()
//            #endif
//
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
    }

    private func row(_ item: Item) -> some View {
        VStack {
            HStack {
                Toggle("Select Recipe", isOn: Binding<Bool>(get: { item.isSelected }, set: { item.isSelected = $0 } ))
                Text(item.recipe.name)
                    .font(.title)
                    .padding(.top)
            }
            Text("For \(item.recipe.mealCount) \(item.recipe.mealCount == 1 ? "meal" : "meals")")
                .padding(.bottom)

            VStack(alignment: .leading) {
                ForEach(item.recipe.ingredients, id: \.name) { (ingredient: Ingredient) in
                    Text("\(ingredient.name) \(ingredient)" as String)
                }
            }
        }
    }

    // Keep that code for later, could be useful after learning CoreData
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(
            initialState: RecipesState(),
            reducer: recipesReducer,
            environment: .mock
        ))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
