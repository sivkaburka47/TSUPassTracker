//
//  SignUpRepositoryImpl.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

import KeychainAccess

class SignUpRepositoryImpl: SignUpRepository {
    private let httpClient: HTTPClient
    private let keychain: Keychain
    
    init(httpClient: HTTPClient, keychain: Keychain) {
        self.httpClient = httpClient
        self.keychain = keychain
    }
    
    func registerUser(request: UserRegisterModel) async throws -> UserAuthResponseModel {
        let endpoint = UserRegisterEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: request)
    }
    
    func saveToken(token: String) throws {
        try keychain.set(token, key: "authToken")
    }
}

