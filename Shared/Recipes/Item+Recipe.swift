import Foundation

extension Item {
    var recipe: Recipe {
        guard let data = self.serializedRecipe
        else { return .error }
        do {
            let recipe = try JSONDecoder().decode(Recipe.self, from: data)
            return recipe
        } catch {
            print(error)
            return .error
        }
    }
}
