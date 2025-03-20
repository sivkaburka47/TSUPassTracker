//
//  BaseURL.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

enum BaseURL {
    case local
    case server

    var baseURL: String {
        switch self {
        case .local:
            return "http://localhost:5159"
        case .server:
            return ""
        }
    }
}
