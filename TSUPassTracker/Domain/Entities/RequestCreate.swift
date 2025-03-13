//
//  RequestCreate.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation

struct RequestCreate {
    var dateFrom: Date?
    var dateTo: Date?
    var confirmationType: ConfirmationTypeEntity
    var files: [FileData]
    
    init(dateFrom: Date? = nil, dateTo: Date? = nil, confirmationType: ConfirmationTypeEntity = .medical, files: [FileData] = []) {
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.confirmationType = confirmationType
        self.files = files
    }
}

