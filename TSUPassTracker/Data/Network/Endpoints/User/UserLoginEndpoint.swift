//
//  UserLoginEndpoint.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

import Alamofire

struct UserLoginEndpoint: APIEndpoint {
    var path: String {
        return "/api/User/login"
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}

