//
//  LightRequest.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 09.03.2025.
//

import Foundation

struct ListLightRequests {
    let listLightRequests: [LightRequest]
    
    init(listLightRequests: [LightRequest] = []){
        self.listLightRequests = listLightRequests
    }
}

struct LightRequest {
    let id: String
    let createdDate: Date
    let dateFrom: Date
    let dateTo: Date?
    let userName: String
    let status: RequestStatusEntity
    let confirmationType: ConfirmationTypeEntity
    
    init(id: String = SC.empty,
         createdDate: Date = Date(),
         dateFrom: Date = Date(),
         dateTo: Date? = nil,
         userName: String = SC.empty,
         status: RequestStatusEntity = .pending,
         confirmationType: ConfirmationTypeEntity = .family
    ){
        self.id = id
        self.createdDate = createdDate
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.userName = userName
        self.status = status
        self.confirmationType = confirmationType
    }
}

enum RequestStatusEntity: String {
    case pending = "В ожидании"
    case approved = "Принято"
    case rejected = "Отклонено"
    
    init(from requestStatus: RequestStatus) {
        switch requestStatus {
        case .pending:
            self = .pending
        case .approved:
            self = .approved
        case .rejected:
            self = .rejected
        }
    }
}

enum ConfirmationTypeEntity: String {
    case medical = "Медицинская"
    case family = "Семейная"
    case educational = "Учебная"
    
    init(from confirmationType: ConfirmationType) {
        switch confirmationType {
        case .medical:
            self = .medical
        case .family:
            self = .family
        case .educational:
            self = .educational
        }
    }
}
