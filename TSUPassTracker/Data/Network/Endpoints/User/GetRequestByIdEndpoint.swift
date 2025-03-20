//
//  GetRequestByIdEndpoint.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 13.03.2025.
//

import Alamofire
import KeychainAccess

struct GetRequestByIdEndpoint: APIEndpoint {
    let id: String
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken")
    }
    
    var path: String {
        return "/api/Request/\(id)"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token = authToken else { return nil }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
}



