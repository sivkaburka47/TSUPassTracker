//
//  RequestModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 13.03.2025.
//

import Foundation

struct RequestModel: Codable {
    let id: String
    let createdDate: String
    let dateFrom: String
    let dateTo: String?
    let userId: String
    let userName: String
    let status: RequestStatus
    let confirmationType: ConfirmationType
    let files: [String]
}
