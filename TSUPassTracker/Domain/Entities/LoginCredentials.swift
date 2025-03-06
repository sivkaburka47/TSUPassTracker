//
//  LoginCredentials.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

struct LoginCredentials {
    var username: String
    var password: String
    
    init(username: String = "", password: String = "") {
        self.username = username
        self.password = password
    }
}

