//
//  LogoutRepositoryImpl.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

import KeychainAccess

class LogoutRepositoryImpl: LogoutRepository {
    private let httpClient: HTTPClient
    private let keychain: Keychain
    
    init(httpClient: HTTPClient, keychain: Keychain) {
        self.httpClient = httpClient
        self.keychain = keychain
    }
    
    func logout() async throws -> UserAuthResponseModel {
        let endpoint = LogoutEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
    func removeToken() throws {
        try keychain.remove("authToken")
    }
}

