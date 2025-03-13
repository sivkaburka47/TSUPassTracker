//
//  CreateRequestUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

protocol CreateRequestUseCase {
    func execute(request: RequestCreateDTO) async throws -> CreateRequestResponse
}

class CreateRequestUseCaseImpl: CreateRequestUseCase {
    private let repository: CreateRequestRepository
    
    init(repository: CreateRequestRepository) {
        self.repository = repository
    }
    
    static func create() -> CreateRequestUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .local)
        let repository = CreateRequestRepositoryImpl(httpClient: httpClient)
        return CreateRequestUseCaseImpl(repository: repository)
    }
    
    func execute(request: RequestCreateDTO) async throws -> CreateRequestResponse {
        do {
            let response = try await repository.createRequest(request: request)
            return response
        } catch {
            throw error
        }
    }
}
