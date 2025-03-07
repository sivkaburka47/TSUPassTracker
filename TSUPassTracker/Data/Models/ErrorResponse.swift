//
//  ErrorResponse.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

struct ErrorResponse: Decodable {
    let status: Int
    let message: String?
    let details: String?
    let type: String?
    let title: String?
    let errors: [String: [String]]?
    let traceId: String?
}
