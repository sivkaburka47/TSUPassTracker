//
//  FileData.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation

struct FileData: Equatable {
    let data: Data
    let fileName: String
    let mimeType: String
    
    var fileExtension: String {
        URL(fileURLWithPath: fileName).pathExtension.lowercased()
    }
    
    var systemIconName: String {
        switch fileExtension {
        case "pdf": return "doc.richtext"
        case "jpg", "jpeg", "png": return "photo"
        case "doc", "docx": return "doc.text"
        case "xls", "xlsx": return "chart.bar.doc.horizontal"
        default: return "doc"
        }
    }
    
    var base64String: String {
        data.base64EncodedString()
    }
}
