//
//  UserRegisterModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

struct UserRegisterModel: Codable {
    let name: String
    let login: String
    let roles: [Role]
    let password: String
    let group: String
}

