//
//  GetUserDataUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

protocol GetUserDataUseCase {
    func execute() async throws -> UserModel
}

class GetUserDataUseCaseImpl: GetUserDataUseCase {
    private let repository: GetUserDataRepository
    
    init(repository: GetUserDataRepository) {
        self.repository = repository
    }
    
    static func create() -> GetUserDataUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .local)
        let repository = GetUserDataRepositoryImpl(httpClient: httpClient)
        return GetUserDataUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> UserModel {
        do {
            let response = try await repository.getUserData()
            return response
        } catch {
            throw error
        }
    }
}

