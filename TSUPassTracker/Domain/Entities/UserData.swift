//
//  UserData.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

import Foundation

struct UserData {
    let id: String
    let isConfirmed: Bool
    let name: String
    let group: String?
    let roles: [RoleData]
    
    init(id: String = "", isConfirmed: Bool = false, name: String = "", group: String? = nil, roles: [Role] = []) {
        self.id = id
        self.isConfirmed = isConfirmed
        self.name = name
        self.group = group
        self.roles = roles.compactMap { RoleData(from: $0) }
    }
}

enum RoleData: String {
    case student = "Студент"
    case teacher = "Преподаватель"
    case dean = "Деканат"
    
    init?(from role: Role) {
        switch role {
        case .student:
            self = .student
        case .teacher:
            self = .teacher
        case .dean:
            self = .dean
        }
    }
}
