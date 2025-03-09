//
//  AuthService.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import Foundation
import KeychainAccess

protocol AuthServiceProtocol {
    var isAuthenticated: Bool { get }
    func logout()
}

final class AuthService: AuthServiceProtocol {
    private let keychain = Keychain()
    private let authTokenKey = "authToken"
    
    var isAuthenticated: Bool {
        return keychain[authTokenKey] != nil
    }
    
    init() {
        print("Токен в Keychain: \(keychain[authTokenKey] ?? "отсутствует")")
    }
    
    func logout() {
        do {
            try keychain.remove(authTokenKey)
            print("Токен удален из Keychain.")
        } catch {
            print("Ошибка удаления токена: \(error)")
        }
    }
}
