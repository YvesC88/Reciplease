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
    
    let details = Recipe()
    
    init(recipe: Recipe) {
        ingredientsTextView.text = recipe.ingredientLines.first
    }
}
