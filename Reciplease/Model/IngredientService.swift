//
//  IngredientService.swift
//  Reciplease
//
//  Created by Yves Charpentier on 27/05/2022.
//

import Foundation

enum IngredientServiceError: Error {
    case alreadyExist
}

class IngredientService {
    
    // MARK: Singleton pattern
    
    static let shared = IngredientService()
    private init() {}
    
    // MARK: - Properties
    
    var newArray: [String] = []
    private(set) var ingredients: [Ingredient] = []
    
    // MARK: - Methods
    
    func add(ingredient: Ingredient) throws {
        guard newArray.contains(ingredient.name.uppercased()) else {
            ingredients.append(ingredient)
            newArray.append(ingredient.name.uppercased())
            return
        }
        throw IngredientServiceError.alreadyExist
    }
    
    func remove(at index: Int) {
        ingredients.remove(at: index)
        newArray.remove(at: index)
    }
    
    func clear() {
        ingredients.removeAll()
        newArray.removeAll()
    }
}
