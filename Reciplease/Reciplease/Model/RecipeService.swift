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
    
    let qParam = IngredientService.shared.ingredients.first!.name
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    //        func getValue(callback: @escaping (Welcome?) -> Void) {
    //            let url = "https://api.edamam.com/api/recipes/v2"
    //            let parameters = [
    //                "type": "public",
    //                "q": "\(IngredientService.shared.ingredients.first!.name)",
    //                "app_id": "089204a1",
    //                "app_key": "3d30c9ee6f670bb3194a8533adfde190"
    //            ]
    //
    //            AF.request(url,
    //                       method: .get,
    //                       parameters: parameters,
    //                       encoder: JSONParameterEncoder.default).responseDecodable(of: Welcome.self) { response in
    //                guard let recipe = response.value else {
    //                    callback(nil)
    //                    print("Error")
    //                    return
    //                }
    //                callback(recipe)
    //                print("Success")
    //            }
    //        }
    
    
    // URLSession fonctionnel
    
    func getValue(callback: @escaping (ResultRecipe?) -> Void) {
        let urlString = URL(string:"https://api.edamam.com/api/recipes/v2?type=public&q=\(qParam)&app_id=089204a1&app_key=3d30c9ee6f670bb3194a8533adfde190")
        var request = URLRequest(url: urlString!)
        request.httpMethod = "GET"
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(nil)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(nil)
                return
            }
            do {
                let responseJSON = try JSONDecoder().decode(ResultRecipe.self, from: data)
                callback(responseJSON)
            } catch {
                callback(nil)
            }
        }
        task?.resume()
    }
}
