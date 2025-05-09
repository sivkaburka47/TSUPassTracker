//
//  CreateRequestUseCaseRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

protocol CreateRequestRepository {
    func createRequest(request: RequestCreateDTO) async throws -> CreateRequestResponse
    func updateRequest(requestId: String, request: RequestUpdateModel) async throws -> UpdateRequestResponse
}

