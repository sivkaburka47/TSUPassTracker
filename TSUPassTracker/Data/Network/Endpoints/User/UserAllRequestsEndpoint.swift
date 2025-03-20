//
//  UserAllRequestsEndpoint.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

import Alamofire
import KeychainAccess

struct UserAllRequestsEndpoint: APIEndpoint {
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken")
    }
    
    let confirmationType: ConfirmationType?
    let status: RequestStatus?
    let sort: SortEnum?
    let page: Int
    let size: Int
    
    var path: String {
        return "/api/User/requests"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Alamofire.Parameters? {
        var params: Parameters = [
            "page": page,
            "size": size
        ]
        if let confirmationType = confirmationType?.rawValue {
            params["confirmationType"] = confirmationType
        }
        if let status = status?.rawValue {
            params["status"] = status
        }
        if let sort = sort?.rawValue {
            params["sort"] = sort
        }
        return params
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token = authToken else { return nil }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
}


