//
//  GetUserAllRequestsRepository.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

protocol GetUserAllRequestsRepository {
    func getUserRequests( confirmationType: ConfirmationType?,
                          status: RequestStatus?,
                          sort: SortEnum?,
                          page: Int,
                          size: Int) async throws -> LightRequestsPagedListModel
    
    func getRequestById(requestId: String) async throws -> RequestModel
}

