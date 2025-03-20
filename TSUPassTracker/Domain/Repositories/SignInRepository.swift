//
//  SignInRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

protocol SignInRepository {
    func authorizeUser(request: LoginCredentialsRequestModel) async throws -> UserAuthResponseModel
    func saveToken(token: String) throws
}

