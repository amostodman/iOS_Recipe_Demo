//
//  Recipe.swift
//  Recipes
//
//  Created by Amos Todman on 3/8/22.
//

import Foundation

// MARK: - RECIPE -

struct Recipe: Codable {
    var idMeal: String? = ""
    var strMeal: String? = ""
    var strMealThumb: String? = ""
    var dateModified: String? = ""
    var strArea: String? = ""
    var strCategory: String? = ""
    var strCreativeCommonsConfirmed: String? = ""
    var strDrinkAlternate: String? = ""
    var strImageSource: String? = ""
    var strIngredient1: String? = ""
    var strIngredient10: String? = ""
    var strIngredient11: String? = ""
    var strIngredient12: String? = ""
    var strIngredient13: String? = ""
    var strIngredient14: String? = ""
    var strIngredient15: String? = ""
    var strIngredient16: String? = ""
    var strIngredient17: String? = ""
    var strIngredient18: String? = ""
    var strIngredient19: String? = ""
    var strIngredient2: String? = ""
    var strIngredient20: String? = ""
    var strIngredient3: String? = ""
    var strIngredient4: String? = ""
    var strIngredient5: String? = ""
    var strIngredient6: String? = ""
    var strIngredient7: String? = ""
    var strIngredient8: String? = ""
    var strIngredient9: String? = ""
    var strInstructions: String? = ""
    var strMeasure1: String? = ""
    var strMeasure10: String? = ""
    var strMeasure11: String? = ""
    var strMeasure12: String? = ""
    var strMeasure13: String? = ""
    var strMeasure14: String? = ""
    var strMeasure15: String? = ""
    var strMeasure16: String? = ""
    var strMeasure17: String? = ""
    var strMeasure18: String? = ""
    var strMeasure19: String? = ""
    var strMeasure2: String? = ""
    var strMeasure20: String? = ""
    var strMeasure3: String? = ""
    var strMeasure4: String? = ""
    var strMeasure5: String? = ""
    var strMeasure6: String? = ""
    var strMeasure7: String? = ""
    var strMeasure8: String? = ""
    var strMeasure9: String? = ""
    var strSource: String? = ""
    var strTags: String? = ""
    var strYoutube: String? = ""
    
    var ingredients: [Ingredient]?
    
    static func recipes(from array: [[String: AnyObject]]) -> [Recipe] {
        var recipes = [Recipe]()
        
        do {
            let recipesData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            recipes = try JSONDecoder().decode([Recipe].self, from: recipesData)
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
        recipes.sort{ $0.strMeal ?? "" < $1.strMeal ?? ""}
        return recipes
    }
    
    mutating func updateIngredients() {
        // remove possible duplicates
        var initialIngredients = Array(Set(Ingredient.ingredients(from: self)))
        
        // sort by the index
        initialIngredients.sort{ $0.index < $1.index }
        ingredients = initialIngredients
    }
    
    static func getRecipes(with category: RecipeCategory, completion: (([Recipe]) -> Void)?) {
        guard
            let categoryString = category.strCategory,
            let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(categoryString)")
        else {
            print("Could not create URL")
            return
        }
        
        Network.post(url: url, params: nil) { json in
            guard let recipesArray = json["meals"] as? [[String: AnyObject]] else {
                print("could not create recipes from json: \(json)")
                return
            }
            
            let recipes = Recipe.recipes(from: recipesArray)
            completion?(recipes)
        }
    }
    
    static func getRecipeInstruction(with recipe: Recipe, completion: ((Recipe) -> Void)?) {
        guard
            let mealId = recipe.idMeal,
            let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)")
        else {
            print("Could not create URL")
            return
        }
        
        Network.post(url: url, params: nil) { json in
            guard let recipeInstructionArray = json["meals"] as? [[String: AnyObject]] else {
                print("could not create recipes from json: \(json)")
                return
            }
            
            guard var recipeResult = Recipe.recipes(from: recipeInstructionArray).first else {
                print("could not get recipe from array: \(recipeInstructionArray)")
                return
            }
            
            recipeResult.updateIngredients()
            completion?(recipeResult)
        }
    }
}

// MARK: - RECIPE CATEGORY -

struct RecipeCategory: Codable {
    var strCategory: String? = ""
    var strCategoryDescription: String? = ""
    var idCategory: String? = ""
    var strCategoryThumb: String? = ""
    
    static func categories(from array: [[String: AnyObject]]) -> [RecipeCategory] {
        var categories = [RecipeCategory]()
        
        do {
            let categoriesData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            categories = try JSONDecoder().decode([RecipeCategory].self, from: categoriesData)
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
        // sort by category name
        categories.sort { ($0.strCategory ?? "") < ($1.strCategory ?? "") }
        return categories
    }
    
    static func getRecipeCategories(completion:  (([RecipeCategory]) -> Void)?) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else {
            print("Could not create URL")
            return
        }
        
        Network.post(url: url, params: nil) { json in
            guard let categories = json["categories"] as? [[String: AnyObject]] else {
                print("could not create categories from json: \(json)")
                return
            }
            
            let recipeCategories = RecipeCategory.categories(from: categories)
            
            completion?(recipeCategories)
        }
    }
}

// MARK: - INGREDIENT -

struct Ingredient: Codable, Equatable, Hashable {
    var name = ""
    var measure = ""
    var index: Int = -1
    
    // MARK: - INGREDIENT MAPPING
    
    static func ingredients(from recipe: Recipe) -> [Ingredient] {
        var ingredients = [Ingredient]()
        
        ingredients = addIngredient(ingredientString: recipe.strIngredient1, ingrediantMeasure: recipe.strMeasure1, ingredientIndex: 1, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient2, ingrediantMeasure: recipe.strMeasure2, ingredientIndex: 2, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient3, ingrediantMeasure: recipe.strMeasure3, ingredientIndex: 3, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient4, ingrediantMeasure: recipe.strMeasure4, ingredientIndex: 4, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient5, ingrediantMeasure: recipe.strMeasure5, ingredientIndex: 5, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient6, ingrediantMeasure: recipe.strMeasure6, ingredientIndex: 6, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient7, ingrediantMeasure: recipe.strMeasure7, ingredientIndex: 7, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient8, ingrediantMeasure: recipe.strMeasure8, ingredientIndex: 8, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient9, ingrediantMeasure: recipe.strMeasure9, ingredientIndex: 9, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient10, ingrediantMeasure: recipe.strMeasure10, ingredientIndex: 10, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient11, ingrediantMeasure: recipe.strMeasure11, ingredientIndex: 11, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient12, ingrediantMeasure: recipe.strMeasure12, ingredientIndex: 12, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient13, ingrediantMeasure: recipe.strMeasure13, ingredientIndex: 13, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient14, ingrediantMeasure: recipe.strMeasure14, ingredientIndex: 14, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient15, ingrediantMeasure: recipe.strMeasure15, ingredientIndex: 15, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient16, ingrediantMeasure: recipe.strMeasure16, ingredientIndex: 16, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient17, ingrediantMeasure: recipe.strMeasure17, ingredientIndex: 17, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient18, ingrediantMeasure: recipe.strMeasure18, ingredientIndex: 18, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient19, ingrediantMeasure: recipe.strMeasure19, ingredientIndex: 19, to: ingredients)
        ingredients = addIngredient(ingredientString: recipe.strIngredient20, ingrediantMeasure: recipe.strMeasure20, ingredientIndex: 20, to: ingredients)
        
        return ingredients
    }
    
    static func addIngredient(ingredientString: String?, ingrediantMeasure: String?, ingredientIndex: Int, to array: [Ingredient]) -> [Ingredient] {
        var ingredient = Ingredient()
        var ingredients = array
        
        if let ingrediantName = ingredientString {
            ingredient.name = ingrediantName
        }
        
        if let ingrediantMeasure = ingrediantMeasure {
            ingredient.measure = ingrediantMeasure
        }
        
        if
            !ingredient.name.isEmpty,
            !ingredients.contains(ingredient)
        {
            ingredient.index = ingredientIndex
            ingredients.append(ingredient)
        }
        
        ingredients.sort { $0.index < $1.index}
        return ingredients
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.measure == rhs.measure
    }
}
