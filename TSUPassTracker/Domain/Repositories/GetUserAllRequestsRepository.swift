//
//  GetUserAllRequestsRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

protocol GetUserAllRequestsRepository {
    func getUserRequests() async throws -> ListLightRequestsDTO
    func getRequestById(requestId: String) async throws -> RequestModel
}

