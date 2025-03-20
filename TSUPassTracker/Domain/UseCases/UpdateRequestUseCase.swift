//
//  UpdateRequestUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 13.03.2025.
//

protocol UpdateRequestUseCase {
    func execute(requestId: String, request: RequestUpdateModel) async throws -> UpdateRequestResponse
}

class UpdateRequestUseCaseImpl: UpdateRequestUseCase {
    private let repository: CreateRequestRepository
    
    init(repository: CreateRequestRepository) {
        self.repository = repository
    }
    
    static func create() -> UpdateRequestUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .local)
        let repository = CreateRequestRepositoryImpl(httpClient: httpClient)
        return UpdateRequestUseCaseImpl(repository: repository)
    }
    
    func execute(requestId: String, request: RequestUpdateModel) async throws -> UpdateRequestResponse {
        do {
            let response = try await repository.updateRequest(requestId: requestId, request: request)
            return response
        } catch {
            throw error
        }
    }
}

