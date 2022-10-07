//
//  LocalRecipe.swift
//  Reciplease
//
//  Created by Yves Charpentier on 28/06/2022.
//

import Foundation
import CoreData

class LocalRecipe: NSManagedObject { }

extension LocalRecipe {
    
    // MARK: - Methods
    
    func toRecipe() -> Recipe {
        return Recipe(title: title,
                      subtitle: subtitle,
                      image: recipeImage,
                      like: Int(like),
                      time: Double(time),
                      detailIngredients: ingredientLines,
                      uri: uri,
                      url: url)
    }
}
