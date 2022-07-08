//
//  LocalRecipe.swift
//  Reciplease
//
//  Created by Yves Charpentier on 28/06/2022.
//

import Foundation
import CoreData

class LocalRecipe: NSManagedObject {
    
}

extension LocalRecipe {
    func toRecipe() -> Recipe {
        return Recipe(title: title,
                      subtitle: subtitle,
                      image: recipeImage,
                      like: like,
                      time: Int(time),
                      detailIngredients: ingredientLines,
                      url: url)
    }
}
