//
//  RecipeService.swift
//  Reciplease
//
//  Created by Yves Charpentier on 31/05/2022.
//

import Foundation
import Alamofire
import UIKit
import CoreData

class RecipeService {
    
    // MARK: - Singleton pattern
    
    static let shared = RecipeService()
    public var networkService: NetworkServiceProtocol = NetworkService()
    init() {}
    
    // MARK: - Properties
    
    public var coreDataStack: CoreDataStackProtocol = CoreDataStack.share
    
    // MARK: - Methods
    
    func getValue(callback: @escaping (ResultRecipe?) -> Void) {
        var ingredients: [String] = []
        for i in IngredientService.shared.ingredients {
            ingredients += [i.name]
        }
        let url = "https://api.edamam.com/api/recipes/v2"
        let parameters = [
            "type": "public",
            "q" : ingredients.joined(separator: ","),
            "app_id": "089204a1",
            "app_key": "3d30c9ee6f670bb3194a8533adfde190"
        ] as [String : Any]
        
        networkService.get(url: url, parameters: parameters) { response in
            callback(response)
        }
    }
    
    func saveRecipe(title: String?, subtitle: String?, with recipeImage: Data?, ingredientLines: String?, like: Int?, time: Double?, uri: String?, url: String?) {
        let recipes = LocalRecipe(context: CoreDataStack.share.viewContext)
        recipes.title = title
        recipes.subtitle = subtitle
        recipes.recipeImage = recipeImage
        recipes.ingredientLines = ingredientLines
        recipes.like = Int64(like ?? 0)
        recipes.time = Double(time ?? 0)
        recipes.uri = uri
        recipes.url = url
        do {
            try coreDataStack.save()
        } catch {
            print("Error \(error)")
        }
    }
    
    func unsaveRecipe(uri: String) {
        do {
            try coreDataStack.unSave(uri: uri)
        } catch {
            print("Error : \(error)")
        }
    }
    
    func isFavorite(recipeURI: String) -> Bool {
        var stateFavoriteButton: Bool
        let context = CoreDataStack.share.viewContext
        let fetchRequest: NSFetchRequest<LocalRecipe>
        fetchRequest = LocalRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uri == %@", recipeURI)
        let uriID = try? context.fetch(fetchRequest)
        if uriID?.count ?? 1 > 0 {
            stateFavoriteButton = true
        } else {
            stateFavoriteButton = false
        }
        return stateFavoriteButton
    }
}
