//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Amos Todman on 3/8/22.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum PageType {
        case categories
        case recipes
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipeCategories = [RecipeCategory]()
    var selectedCategory: RecipeCategory?
    var recipes = [Recipe]()
    var pageType: PageType = .categories
    
    // MARK: - UIVIEWCONTROLLER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Categories", comment: "recipesView.categories.navbar.title")
        if pageType == .recipes {
            navigationItem.title = NSLocalizedString("Recipes", comment: "recipesView.recipes.navbar.title") 
        }
        
        setupTableView()
    }
    
    // MARK: - UITABLEVIEW
    
    func setupTableView() {
        switch pageType {
        case .categories:
            getRecipeCategories()
        case .recipes:
            guard let category = selectedCategory else {
                print("selectedCategory is nil")
                return
            }
            getRecipes(with: category)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch pageType {
        case .categories:
            return recipeCategories.count
        case .recipes:
            return recipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "RecipesCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RecipesCell else {
            print("Could not create RecipesCell")
            return UITableViewCell()
        }
        
        switch pageType {
        case .categories:
            let category = recipeCategories[indexPath.row]
            cell.configureWithCategory(category: category)
        case .recipes:
            let recipe = recipes[indexPath.row]
            cell.configureWithRecipe(recipe: recipe)
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch pageType {
        case .categories:
            showRecipesView(for: recipeCategories[indexPath.row])
        case .recipes:
            let recipe = recipes[indexPath.row]
            showRecipeView(for: recipe)
        }
    }
    
    // MARK: - PRIVATE
    private func getRecipeCategories() {
        RecipeCategory.getRecipeCategories { categories in
            self.recipeCategories = categories
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getRecipes(with category: RecipeCategory) {
        Recipe.getRecipes(with: category) { recipeArray in
            self.recipes = recipeArray
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - NAVIGATION
    
    func showRecipesView(for category: RecipeCategory) {
        guard let vc = storyboard?.instantiateViewController(identifier: "RecipesViewController") as? RecipesViewController else {
            print("could not instantiate RecipesViewController")
            return
        }
        
        vc.pageType = .recipes
        vc.selectedCategory = category
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showRecipeView(for recipe: Recipe) {
        guard let vc = storyboard?.instantiateViewController(identifier: "RecipeViewController") as? RecipeViewController else {
            print("could not instantiate RecipeViewController")
            return
        }
        
        vc.recipe = recipe
        navigationController?.pushViewController(vc, animated: true)
    }
}

