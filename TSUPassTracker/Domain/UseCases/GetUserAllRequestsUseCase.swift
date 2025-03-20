//
//  GetUserAllRequestsUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

protocol GetUserAllRequestsUseCase {
    func execute(
        confirmationType: ConfirmationType?,
        status: RequestStatus?,
        sort: SortEnum?,
        page: Int,
        size: Int
    ) async throws -> LightRequestsPagedListModel
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
    
    
    func execute(
        confirmationType: ConfirmationType?,
        status: RequestStatus?,
        sort: SortEnum?,
        page: Int,
        size: Int
    ) async throws -> LightRequestsPagedListModel {
        do {
            return try await repository.getUserRequests(
                confirmationType: confirmationType,
                status: status,
                sort: sort,
                page: page,
                size: size
            )
        } catch {
            throw error
        }
    }
}


