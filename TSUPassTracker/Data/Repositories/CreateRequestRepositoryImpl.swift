//
//  CreateRequestRepositoryImpl.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import KeychainAccess

class CreateRequestRepositoryImpl: CreateRequestRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func createRequest(request: RequestCreateDTO) async throws -> CreateRequestResponse {
        let endpoint = CreateRequestEndpoint()
        return try await httpClient.sendMultipartRequest(endpoint: endpoint, multipartData: request)
    }
}
