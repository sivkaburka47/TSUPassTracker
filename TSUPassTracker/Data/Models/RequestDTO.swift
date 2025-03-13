//
//  RequestDTO.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation
import Alamofire

protocol MultipartDataConvertible {
    func configureMultipartData(_ formData: MultipartFormData)
}

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


struct RequestUpdateModel {
    let dateFrom: String?
    let dateTo: String?
    let files: [MultipartFile]
}

extension RequestCreateDTO: MultipartDataConvertible {
    func configureMultipartData(_ formData: MultipartFormData) {
        formData.append(
            Data(dateFrom.utf8),
            withName: "DateFrom",
            mimeType: "text/plain"
        )
        
        if let dateTo = dateTo {
            formData.append(
                Data(dateTo.utf8),
                withName: "DateTo",
                mimeType: "text/plain"
            )
        }
        
        let typeString = confirmationType.rawValue
        formData.append(
            Data(typeString.utf8),
            withName: "ConfirmationType",
            mimeType: "text/plain"
        )
        
        for file in files {
            formData.append(
                file.data,
                withName: "Files",
                fileName: file.fileName,
                mimeType: file.mimeType
            )
        }
    }
}

extension RequestUpdateModel: MultipartDataConvertible {
    func configureMultipartData(_ formData: MultipartFormData) {
        if let dateFrom = dateFrom {
            formData.append(
                Data(dateFrom.utf8),
                withName: "DateFrom",
                mimeType: "text/plain"
            )
        }
        
        if let dateTo = dateTo {
            formData.append(
                Data(dateTo.utf8),
                withName: "DateTo",
                mimeType: "text/plain"
            )
        }
        
        for file in files {
            formData.append(
                file.data,
                withName: "Files",
                fileName: file.fileName,
                mimeType: file.mimeType
            )
        }
    }
}
