//
//  CreateRequestUseCaseRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

protocol CreateRequestRepository {
    func createRequest(request: RequestCreateDTO) async throws -> CreateRequestResponse
}

