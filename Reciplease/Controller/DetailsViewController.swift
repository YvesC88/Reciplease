//
//  DetailsViewController.swift
//  Reciplease
//
//  Created by Yves Charpentier on 12/06/2022.
//

import Foundation
import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var titleRecipeLabel: UILabel!
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    // MARK: - Properties
    
    var recipe: Recipe!
    
    // MARK: Instantiated controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView(view: effectView)
        setupImage()
        setupUI()
        setupVoiceOver()
    }
    
    // MARK: - Methods
    
    private func setupImage() {
        guard let imageData = recipe?.image else { return }
        let image = UIImage(data: imageData)
        recipeImageView.image = image
    }
    
    private func setupUI() {
        ingredientsTextView.text = recipe.detailIngredients
        titleRecipeLabel.text = recipe.title
        guard RecipeService.shared.isFavorite(recipeURI: recipe.uri!) else {
            favoriteButton.isSelected = false
            return
        }
        favoriteButton.isSelected = true
    }
    
    private func customView(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.cornerRadius = 15
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    @IBAction func getFavoriteRecipe() {
        let isFavorite: Bool = RecipeService.shared.isFavorite(recipeURI: recipe.uri ?? "")
        guard isFavorite else {
            RecipeService.shared.saveRecipe(title: recipe.title,
                                            subtitle: recipe.subtitle,
                                            with: recipe.image,
                                            ingredientLines: recipe.detailIngredients,
                                            like: Int(recipe.like ?? 0),
                                            time: Double(recipe.time ?? 0),
                                            uri: recipe.uri,
                                            url: recipe.url)
            presentAlert(title: "Congrats!", message: "Your recipe is in favorites.")
            favoriteButton.isSelected = true
            return
        }
        RecipeService.shared.unsaveRecipe(uri: recipe.uri!)
        navigationController?.popViewController(animated: true)
        favoriteButton.isSelected = false
    }
    
    @IBAction func getDirections() {
        UIApplication.shared.open(URL(string: recipe.url!)!)
    }
    
    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setupVoiceOver() {
        VoiceOver.shared.voiceOver(object: titleRecipeLabel, hint: "The name of the recipe")
        VoiceOver.shared.voiceOver(object: ingredientsTextView, hint: "Quantity of each ingredient")
    }
}
