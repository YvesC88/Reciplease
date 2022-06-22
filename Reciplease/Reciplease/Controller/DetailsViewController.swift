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
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureDisplay()
        recipeDisplay()
        titleRecipeLabel.text = recipe.label
        customView(view: effectView)
    }
    
    func pictureDisplay() {
        let url = URL(string: recipe.images.regular.url)
        if let data = try? Data(contentsOf: url!) {
            let image = UIImage(data: data)
            recipeImageView.image = image
        }
    }
    
    func recipeDisplay() {
        for i in recipe.ingredientLines {
            ingredientsTextView.text += "\n- \(i)"
        }
    }
    
    func customView(view: UIView) {
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        newLayer.cornerRadius = 15
        effectView.layer.addSublayer(newLayer)
    }
}
