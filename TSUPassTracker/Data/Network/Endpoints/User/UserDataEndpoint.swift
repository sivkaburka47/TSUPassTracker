//
//  UserDataEndpoint.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

import Alamofire
import KeychainAccess

struct UserDataEndpoint: APIEndpoint {
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken")
    }
    
    var path: String {
        return "/api/User/profile"
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

