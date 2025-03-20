//
//  LightRequestDTO.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

import Foundation

struct LightRequestsPagedListModel : Codable
{
    let requests: ListLightRequestsDTO
    let pagination: PageInfoModel
}

struct PageInfoModel: Codable
{
    let size: Int
    let count: Int
    let current: Int
}

struct ListLightRequestsDTO: Codable {
    let listLightRequests: [LightRequestDTO]
}

struct LightRequestDTO: Codable {
    let id: String
    let createdDate: String
    let dateFrom: String
    let dateTo: String?
    let userName: String
    let status: RequestStatus
    let confirmationType: ConfirmationType
}

enum RequestStatus: String, Codable {
    case pending = "Pending"
    case approved = "Approved"
    case rejected = "Rejected"
}

enum ConfirmationType: String, Codable {
    case medical = "Medical"
    case family = "Family"
    case educational = "Educational"
}

enum SortEnum: String, Codable {
    case createdAsc = "CreatedAsc"
    case createdDesc = "CreatedDesc"
}
