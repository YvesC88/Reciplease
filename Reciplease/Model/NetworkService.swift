//
//  NetworkService.swift
//  Reciplease
//
//  Created by Yves Charpentier on 26/07/2022.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    
    func get<ResponseType: Mockable>(url: String, parameters: [String : Any], completion: @escaping (ResponseType?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func get<ResponseType: Mockable>(url: String, parameters: [String : Any], completion: @escaping (ResponseType?) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: parameters).responseDecodable(of: ResponseType.self) { response in
            guard let object = response.value else {
                completion(nil)
                return
            }
            completion(object)
        }
    }
}
