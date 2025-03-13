//
//  GetUserAllRequestsRepositoryImpl.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

class GetUserAllRequestsRepositoryImpl: GetUserAllRequestsRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getUserRequests() async throws -> ListLightRequestsDTO {
        let endpoint = UserAllRequestsEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
    func getRequestById(requestId: String) async throws -> RequestModel {
        let endpoint = GetRequestByIdEndpoint(id: requestId)
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
}

