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
                    print("Error")
                    return
                }
                callback(recipe)
                print("Success")

            }
        }
    
//    func getValue(callback: @escaping (ResultRecipe?) -> Void) {
//        var ingredients: [String] = []
//        for i in IngredientService.shared.ingredients {
//            ingredients += [i.name]
//        }
//        print(ingredients.joined(separator: " "))
//        let urlString = URL(string:"https://api.edamam.com/api/recipes/v2?type=public&q=\(ingredients.joined(separator: ","))&app_id=089204a1&app_key=3d30c9ee6f670bb3194a8533adfde190")
//        var request = URLRequest(url: urlString!)
//        print(urlString!)
//        request.httpMethod = "GET"
//        task?.cancel()
//        task = session.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                callback(nil)
//                return
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                callback(nil)
//                return
//            }
//            do {
//                let responseJSON = try JSONDecoder().decode(ResultRecipe.self, from: data)
//                callback(responseJSON)
//            } catch {
//                callback(nil)
//            }
//        }
//        task?.resume()
//    }
}
