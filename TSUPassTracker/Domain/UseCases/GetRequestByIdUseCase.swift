//
//  GetRequestByIdUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 13.03.2025.
//

protocol GetRequestByIdUseCase {
    func execute(requestId: String) async throws -> RequestModel
}

class GetRequestByIdUseCaseImpl: GetRequestByIdUseCase {
    private let repository: GetUserAllRequestsRepository
    
    init(repository: GetUserAllRequestsRepository) {
        self.repository = repository
    }
    
    static func create() -> GetRequestByIdUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .local)
        let repository = GetUserAllRequestsRepositoryImpl(httpClient: httpClient)
        return GetRequestByIdUseCaseImpl(repository: repository)
    }
    
    func execute(requestId: String) async throws -> RequestModel {
        do {
            let response = try await repository.getRequestById(requestId: requestId)
            return response
        } catch {
            throw error
        }
    }
}

