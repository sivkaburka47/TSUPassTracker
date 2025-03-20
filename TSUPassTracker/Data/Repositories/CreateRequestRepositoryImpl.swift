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
    
    // Для создания запроса
    func createRequest(request: RequestCreateDTO) async throws -> CreateRequestResponse {
        let endpoint = CreateRequestEndpoint()
        return try await httpClient.sendMultipartRequest(endpoint: endpoint, multipartData: request)
    }

    // Для обновления запроса
    func updateRequest(requestId: String, request: RequestUpdateModel) async throws -> UpdateRequestResponse {
        let endpoint = UpdateRequestEndPoint(id: requestId)
        return try await httpClient.sendMultipartRequest(endpoint: endpoint, multipartData: request)
    }
}
