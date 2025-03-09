//
//  UserModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let isConfirmed: Bool
    let name: String
    let group: String?
    let roles: [Role]
}

enum Role: String, Codable {
    case student = "Student"
    case teacher = "Teacher"
    case dean = "Dean"
}

