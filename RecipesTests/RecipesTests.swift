//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Amos Todman on 3/8/22.
//

import XCTest
@testable import Recipes

class RecipesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSerializingCategoriesResponse() throws {
        guard
            let json = Helper.jsonFromFile(named: "categories"),
            let categories = json["categories"] as? [[String: AnyObject]]
        else {
            XCTFail("Failed to create categories from json")
            return
        }
        
        let recipeCategories = RecipeCategory.categories(from: categories)
        XCTAssertEqual(recipeCategories.count, 14)
        
        guard let lastCategory = recipeCategories.last else {
            XCTFail("Failed to get last category from categories")
            return
        }
        
        XCTAssertEqual(lastCategory.strCategory, "Vegetarian")
    }
    
    func testSerializingCategoryResponse() throws {
        guard
            let json = Helper.jsonFromFile(named: "category-beef"),
            let recipesArray = json["meals"] as? [[String: AnyObject]]
        else {
            XCTFail("Failed to create recipesArray from json")
            return
        }
        
        let recipes = Recipe.recipes(from: recipesArray)
        
        XCTAssertEqual(recipes.count, 42)
        XCTAssertEqual(recipes[11].strMeal ?? "", "Big Mac")
    }
    
    func testSerializingRecipeResponse() throws {
        guard
            let json = Helper.jsonFromFile(named: "beef-and-mustard-pie-instructions"),
            let recipesArray = json["meals"] as? [[String: AnyObject]]
        else {
            XCTFail("Failed to create recipesArray from json")
            return
        }
        
        guard let recipe = Recipe.recipes(from: recipesArray).first else {
            XCTFail("Failed to get recipe from array: \(recipesArray)")
            return
        }
        
        XCTAssertEqual(recipe.idMeal ?? "", "52874")
        XCTAssertEqual(recipe.strCategory ?? "", "Beef")
        XCTAssertEqual(recipe.strArea ?? "", "British")
    }
    
    func testUpdatingIngredients() throws {
        guard
            let json = Helper.jsonFromFile(named: "beef-and-mustard-pie-instructions"),
            let recipesArray = json["meals"] as? [[String: AnyObject]]
        else {
            XCTFail("Failed to create recipesArray from json")
            return
        }
        
        guard var recipe = Recipe.recipes(from: recipesArray).first else {
            XCTFail("Failed to get recipe from array: \(recipesArray)")
            return
        }
        
        recipe.updateIngredients()
        XCTAssertEqual(recipe.ingredients?.count ?? 0, 15)
        XCTAssertEqual(recipe.ingredients?.last?.name ?? "", "Pepper")
        XCTAssertEqual(recipe.ingredients?.last?.measure ?? "", "pinch")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
