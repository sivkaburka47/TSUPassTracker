//
//  GetUserDataRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

protocol GetUserDataRepository {
    func getUserData() async throws -> UserModel
}
