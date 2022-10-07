//
//  APIRecipe.swift
//  Reciplease
//
//  Created by Yves Charpentier on 31/05/2022.
//
import Foundation
import UIKit

protocol Mockable: Decodable {
    static func mock() -> Self
}

// MARK: - Welcome
struct ResultRecipe: Codable {
    let from, to, count: Int
    let hits: [Hit]
    
    enum CodingKeys: String, CodingKey {
        case from, to, count
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: APIRecipe
}

// MARK: - Recipe
struct APIRecipe: Codable {
    let uri: String
    let label: String
    let image: String
    let images: Images
    let url: String
    let yield: Double
    let ingredientLines: [String]
    let ingredients: [RecipeIngredients]
    let totalTime: Double
}

// MARK: - Ingredient
struct RecipeIngredients: Codable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let foodCategory: String?
    let foodID: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}

// MARK: - Images
struct Images: Codable {
    let thumbnail, small, regular: Large
    let large: Large?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String
    let width, height: Int
}

extension ResultRecipe: Mockable {
    
    static func mock() -> ResultRecipe {
        return ResultRecipe(from: Int.random(in: 0...100), to: Int.random(in: 0...100), count: Int.random(in: 0...100), hits: [])
    }
}

extension APIRecipe {
    
    func toRecipe() -> Recipe {
        guard let imageURL = URL(string: self.images.regular.url) else { return Recipe() }
        var imageData: Data?
        if let data = try? Data(contentsOf: imageURL) {
            imageData = data
        }
        var ingredientLines: String = ""
        for ingredientLine in self.ingredientLines {
            ingredientLines += "\n- \(ingredientLine)"
        }
        var foodLines: [String] = []
        for foodLine in ingredients {
            foodLines.append(foodLine.food)
        }
        return Recipe(title: self.label,
                      subtitle: foodLines.joined(separator: ", ").capitalized,
                      image: imageData,
                      like: Int(self.yield),
                      time: Double(self.totalTime),
                      detailIngredients: ingredientLines,
                      uri: uri,
                      url: url)
    }
}
