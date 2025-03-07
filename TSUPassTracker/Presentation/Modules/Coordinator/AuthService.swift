//
//  AuthService.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

protocol AuthServiceProtocol {
    var isAuthenticated: Bool { get }
    func logout()
}

final class AuthService: AuthServiceProtocol {
    var isAuthenticated = false
    
    func logout() {
        isAuthenticated = false
    }
}
