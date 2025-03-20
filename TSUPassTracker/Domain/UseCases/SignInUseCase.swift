//
//  SignInUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

import KeychainAccess

protocol SignInUseCase {
    func execute(request: LoginCredentialsRequestModel) async throws
}

class SignInUseCaseImpl: SignInUseCase {
    private let repository: SignInRepository
    
    init(repository: SignInRepository) {
        self.repository = repository
    }
    
    static func create() -> SignInUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .local)
        let keychain = Keychain()
        let repository = SignInRepositoryImpl(httpClient: httpClient, keychain: keychain)
        return SignInUseCaseImpl(repository: repository)
    }
    
    func execute(request: LoginCredentialsRequestModel) async throws {
        do {
            let response = try await repository.authorizeUser(request: request)
            try repository.saveToken(token: response.token)
        } catch {
            throw error
        }
    }
}

