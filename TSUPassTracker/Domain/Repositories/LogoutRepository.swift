//
//  LogoutRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

protocol LogoutRepository {
    func logout() async throws -> UserAuthResponseModel
    func removeToken() throws
}

