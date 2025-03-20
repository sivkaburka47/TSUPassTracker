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
    func getUserRoles() -> [String]?
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
    
    func getUserRoles() -> [String]? {
        guard let token = keychain[authTokenKey] else { return nil }
        
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        let payload = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padded = payload.padding(
            toLength: ((payload.count + 3) / 4) * 4,
            withPad: "=",
            startingAt: 0
        )
        
        guard let data = Data(base64Encoded: padded),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        let roleClaim = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
        
        if let roles = json[roleClaim] as? [String] {
            return roles
        } else if let role = json[roleClaim] as? String {
            return [role]
        }
        
        return nil
    }

}
