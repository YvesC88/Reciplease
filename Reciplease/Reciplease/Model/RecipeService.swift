//
//  RecipeService.swift
//  Reciplease
//
//  Created by Yves Charpentier on 31/05/2022.
//

import Foundation
import Alamofire
import UIKit

class RecipeService {
    static let shared = RecipeService()
    private init() {}
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
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
        
        AF.request(url,
                   method: .get,
                   parameters: parameters).responseDecodable(of: ResultRecipe.self) { response in
            guard let recipe = response.value else {
                callback(nil)
                return
            }
            callback(recipe)
            print("Success")
            
        }
    }
    
    func saveRecipe(title: String?, subtitle: String?, with recipeImage: Data?, ingredientLines: String?, like: Double?, time: Int?, uri: String?, url: String?) {
        let recipes = LocalRecipe(context: CoreDataStack.share.viewContext)
        recipes.title = title
        recipes.subtitle = subtitle
        recipes.recipeImage = recipeImage
        recipes.ingredientLines = ingredientLines
        recipes.like = like!
        recipes.time = Int64(time!)
        recipes.uri = uri
        recipes.url = url
        do {
            try CoreDataStack.share.viewContext.save()
        } catch {
            print("Error")
        }
    }
    
    func unsaveRecipe(localRecipe: LocalRecipe) {
        let context = CoreDataStack.share.viewContext
        context.delete(localRecipe)
        do {
            try CoreDataStack.share.viewContext.save()
        } catch {
            print("Error")
        }
    }
}
