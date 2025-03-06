//
//  RegisterCredentials.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

struct RegisterCredentials {
    var name: String
    var surname: String
    var middlename: String
    var group: String
    var username: String
    var password: String
    var repeatedPassword: String
    
    init(name: String = "",surname: String = "",middlename: String = "",group: String = "",username: String = "", password: String = "", repeatedPassword: String = "") {
        self.name = name
        self.surname = surname
        self.middlename = middlename
        self.group = group
        self.username = username
        self.password = password
        self.repeatedPassword = repeatedPassword
    }
}


