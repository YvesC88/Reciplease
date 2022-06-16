//
//  IngredientService.swift
//  Reciplease
//
//  Created by Yves Charpentier on 27/05/2022.
//

import Foundation

class IngredientService {
    static let shared = IngredientService()
    private init() {}

    private(set) var ingredients: [Ingredient] = []

    func add(ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    func remove(at index: Int) {
        ingredients.remove(at: index)
    }
    
    func clear() {
        ingredients = []
    }
}
