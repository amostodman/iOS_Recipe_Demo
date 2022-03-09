//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Amos Todman on 3/8/22.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum TableSections: Int {
        case details
        case ingredients
        case instructions
    }
    
    @IBOutlet weak var tableView: UITableView!
    var recipe: Recipe?
    
    // MARK: - UIVIEWCONTROLLER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    // MARK: - UITABLEVIEW
    
    func setupTable() {
        guard let recipe = recipe else {
            print("recipe is nil")
            return
        }
        
        getRecipeInstruction(with: recipe)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleString = ""
        let tableSection = TableSections(rawValue: section)
        
        switch tableSection {
        case .details:
            titleString = NSLocalizedString("Details", comment: "recipeView.table.sectionTitle.details")
        case .ingredients:
            titleString = NSLocalizedString("Ingredients", comment: "recipeView.table.sectionTitle.ingredients")
        case .instructions:
            titleString = NSLocalizedString("Instructions", comment: "recipeView.table.sectionTitle.instructions")
        default:
            break
        }
        
        return titleString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        let tableSection = TableSections(rawValue: section)
        
        switch tableSection {
        case .details,
             .instructions:
            rowCount = 1
        case .ingredients:
            if let count = recipe?.ingredients?.count {
                rowCount = count
            }
        default:
            break
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = TableSections(rawValue: indexPath.section)
        
        guard let recipe = recipe else {
            print("recipe is nil")
            return UITableViewCell()
        }
        
        switch tableSection {
        case .details:
            let identifier = "RecipesCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RecipesCell else {
                print("Could not create RecipesCell")
                return UITableViewCell()
            }
            
            cell.configureWithRecipe(recipe: recipe)
            return cell
        case .ingredients:
            guard let ingredient = recipe.ingredients?[indexPath.row] else {
                print("could not get ingredients from recipe: \(recipe)")
                break
            }
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: "IngredientCell")
            cell.textLabel?.text = "\(ingredient.measure) \(ingredient.name)"
            return cell
            
        case .instructions:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "IngredientCell")
            cell.textLabel?.text = recipe.strInstructions ?? ""
            cell.textLabel?.numberOfLines = 0
            return cell
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - PRIVATE
    
    private func getRecipeInstruction(with recipe: Recipe) {
        Recipe.getRecipeInstruction(with: recipe) { recipeResult in
            self.recipe = recipeResult
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
