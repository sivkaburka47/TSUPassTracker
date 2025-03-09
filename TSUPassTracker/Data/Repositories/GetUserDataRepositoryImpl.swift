//
//  GetUserDataRepositoryImpl.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

class GetUserDataRepositoryImpl: GetUserDataRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getUserData() async throws -> UserModel {
        let endpoint = UserDataEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
}
