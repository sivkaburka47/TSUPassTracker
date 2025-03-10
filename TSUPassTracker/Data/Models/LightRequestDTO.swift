//
//  LightRequestDTO.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

import Foundation

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
