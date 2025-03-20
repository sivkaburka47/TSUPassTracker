//
//  ValidationErrorResponse.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

struct ValidationErrorResponse: Decodable {
    let type: String
    let title: String
    let status: Int
    let errors: [String: [String]]?
    let traceId: String
}
