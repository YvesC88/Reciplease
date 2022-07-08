//
//  DetailsViewController.swift
//  Reciplease
//
//  Created by Yves Charpentier on 12/06/2022.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var titleRecipeLabel: UILabel!
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    var localRecipe: LocalRecipe!
    var recipe: Recipe!
    var uri: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView(view: effectView)
        viewDisplay()
    }
    
    func viewDisplay() {
        guard let imageData = recipe?.image else {
            favoriteButton.isSelected = true
            ingredientsTextView.text = localRecipe.ingredientLines
            titleRecipeLabel.text = localRecipe.title
            recipeImageView.image = UIImage(data: localRecipe.recipeImage!)
            return
        }
        ingredientsTextView.text = recipe?.detailIngredients
        titleRecipeLabel.text = recipe?.title
        let image = UIImage(data: imageData)
        recipeImageView.image = image
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    func customView(view: UIView) {
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        newLayer.cornerRadius = 15
        effectView.layer.addSublayer(newLayer)
    }
    
    @IBAction func getFavoriteRecipe() {
        if favoriteButton.isSelected {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .selected)
            RecipeService.shared.unsaveRecipe(localRecipe: localRecipe)
            getDirectionsButton.isEnabled = false
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            RecipeService.shared.saveRecipe(title: recipe.title,
                                            subtitle: recipe.subtitle,
                                            with: recipe.image,
                                            ingredientLines: recipe.detailIngredients,
                                            like: recipe.like,
                                            time: recipe.time,
                                            uri: recipe.uri,
                                            url: recipe.url)
            favoriteButton.isSelected = true
        }
    }
    
    @IBAction func getDirections() {
        if localRecipe == localRecipe {
            if let url = URL(string: localRecipe.url!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
