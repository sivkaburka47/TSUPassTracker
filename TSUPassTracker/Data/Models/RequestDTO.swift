//
//  RequestDTO.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation

struct MultipartFile {
    let data: Data
    let fileName: String
    let mimeType: String
}

struct RequestCreateDTO {
    let dateFrom: String
    let dateTo: String?
    let confirmationType: ConfirmationType
    let files: [MultipartFile]
}
