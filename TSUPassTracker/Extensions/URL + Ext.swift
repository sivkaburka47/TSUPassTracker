//
//  URL + Ext.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation

// MARK: - MIME Type Helper
extension URL {
    func mimeType() -> String {
        let ext = pathExtension.lowercased()
        
        let mimeTypes = [
            "pdf": "application/pdf",
            "jpg": "image/jpeg",
            "jpeg": "image/jpeg",
            "png": "image/png",
            "doc": "application/msword",
            "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "xls": "application/vnd.ms-excel",
            "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        ]
        
        return mimeTypes[ext] ?? "application/octet-stream"
    }
}

