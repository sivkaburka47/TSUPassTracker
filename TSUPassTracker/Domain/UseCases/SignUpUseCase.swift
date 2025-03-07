//
//  SignUpUseCase.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

import KeychainAccess

protocol SignUpUseCase {
    func execute(request: UserRegisterModel) async throws
}

class SignUpUseCaseImpl: SignUpUseCase {
    private let repository: SignUpRepository
    
    init(repository: SignUpRepository) {
        self.repository = repository
    }
    
    static func create() -> SignUpUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .local)
        let keychain = Keychain()
        let repository = SignUpRepositoryImpl(httpClient: httpClient, keychain: keychain)
        return SignUpUseCaseImpl(repository: repository)
    }
    
    func execute(request: UserRegisterModel) async throws {
        do {
            let response = try await repository.registerUser(request: request)
            try repository.saveToken(token: response.token)
        } catch {
            throw error
        }
    }
}

