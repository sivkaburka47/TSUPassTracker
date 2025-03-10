//
//  GetUserAllRequestsUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

protocol GetUserAllRequestsUseCase {
    func execute() async throws -> ListLightRequestsDTO
}

class GetUserAllRequestsUseCaseImpl: GetUserAllRequestsUseCase {
    private let repository: GetUserAllRequestsRepository
    
    init(repository: GetUserAllRequestsRepository) {
        self.repository = repository
    }
    
    static func create() -> GetUserAllRequestsUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .local)
        let repository = GetUserAllRequestsRepositoryImpl(httpClient: httpClient)
        return GetUserAllRequestsUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> ListLightRequestsDTO {
        do {
            let response = try await repository.getUserRequests()
            return response
        } catch {
            throw error
        }
    }
}

