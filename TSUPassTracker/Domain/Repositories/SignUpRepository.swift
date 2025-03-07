//
//  SignUpRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

protocol SignUpRepository {
    func registerUser(request: UserRegisterModel) async throws -> UserAuthResponseModel
    func saveToken(token: String) throws
}

