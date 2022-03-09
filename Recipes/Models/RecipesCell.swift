//
//  RecipesCell.swift
//  Recipes
//
//  Created by Amos Todman on 3/8/22.
//

import UIKit

class RecipesCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    func configureWithCategory(category: RecipeCategory) {
        resetUI()
        titleLabel.text = category.strCategory
        descriptionLabel.text = category.strCategoryDescription
        
        if
            let urlString = category.strCategoryThumb,
            let url = URL(string: urlString)
        {
            Network.downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.cellImageView.image = image
                }
            }
        } else {
            self.titleLabelLeadingConstraint.constant = 4
        }
    }
    
    func configureWithRecipe(recipe: Recipe) {
        resetUI()
        titleLabel.text = recipe.strMeal
        
        if
            let urlString = recipe.strMealThumb,
            let url = URL(string: urlString)
        {
            Network.downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.cellImageView.image = image
                }
            }
        } else {
            self.titleLabelLeadingConstraint.constant = 4
        }
    }
    
    func resetUI() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        cellImageView.image = nil
        titleLabelLeadingConstraint.constant = 52
    }
}
