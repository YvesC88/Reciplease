//
//  NetworkServiceMock.swift
//  RecipleaseTests
//
//  Created by Yves Charpentier on 26/07/2022.
//

import Foundation
@testable import Reciplease

class NetworkServiceMock: NetworkServiceProtocol {
    
    var isError: Bool = false
    
    func get<ResponseType: Mockable>(url: String, parameters: [String : Any], completion: @escaping (ResponseType?) -> Void) {
        if isError {
            completion(nil)
        } else {
            completion(ResponseType.mock())
        }
    }
}
