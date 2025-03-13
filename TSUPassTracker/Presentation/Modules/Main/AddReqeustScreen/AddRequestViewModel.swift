//
//  AddRequestViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation

struct CreateRequestResponse: Decodable {
    let id: String
}

struct UpdateRequestResponse: Decodable {
    let message: String
}

final class AddRequestViewModel {
    var request = RequestCreate()
    
    private let createRequestUseCase: CreateRequestUseCase
    private let getRequestByIdUseCase: GetRequestByIdUseCase
    private let updateRequestUseCase: UpdateRequestUseCase
    
    var isAddButtonActive: ((Bool) -> Void)?
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onRequestUpdated: (() -> Void)?

    enum Mode {
        case create
        case edit(requestId: String)
    }
    
    let mode: Mode
    private var requestId: String?
    
    init(mode: Mode) {
        self.mode = mode
        self.createRequestUseCase = CreateRequestUseCaseImpl.create()
        self.getRequestByIdUseCase = GetRequestByIdUseCaseImpl.create()
        self.updateRequestUseCase = UpdateRequestUseCaseImpl.create()
        
        if case .edit(let id) = mode {
            self.requestId = id
            self.getRequest(requestId: id)
        }
    }
    
    func updateConfirmationType(_ type: ConfirmationTypeEntity) {
        request.confirmationType = type
        validateFields()
    }
    
    func updateDateFrom(_ dateFrom: Date) {
        self.request.dateFrom = dateFrom
        validateFields()
    }
    
    func updateDateTo(_ dateTo: Date?) {
        self.request.dateTo = dateTo
        validateFields()
    }
    
    func addFile(_ data: Data, fileName: String) {
        let mimeType = URL(fileURLWithPath: fileName).mimeType()
        request.files.append(FileData(
            data: data,
            fileName: fileName,
            mimeType: mimeType
        ))
        validateFields()
    }
    
    func removeFile(_ file: FileData) {
        request.files.removeAll { $0 == file }
        validateFields()
    }
    
    private func validateFields() {
        let isDateFromValid = request.dateFrom != nil
        let isMedical = request.confirmationType == .medical
        
        let isDateToValid = isMedical ? true : (request.dateTo != nil)
        
        let isFilesValid = request.confirmationType == .family || request.files.count > 0
        
        let isValid = isDateFromValid && isDateToValid && isFilesValid
        isAddButtonActive?(isValid)
    }
    
    func getRequest(requestId: String) {
        Task {
            do {
                let requestModel = try await getRequestByIdUseCase.execute(requestId: requestId)
                
                let dateFormatter = ISO8601DateFormatter()
                let dateFrom = dateFormatter.date(from: requestModel.dateFrom)
                let dateTo = requestModel.dateTo.flatMap { dateFormatter.date(from: $0) }
                
                print("Parsed dateTo: \(String(describing: dateTo))")
                
                let confirmationType = ConfirmationTypeEntity(from: requestModel.confirmationType)
                
                let files = requestModel.files.compactMap { base64String -> FileData? in
                    guard let data = Data(base64Encoded: base64String) else { return nil }
                    let (ext, mime) = guessFileType(from: data)
                    let fileName = "file.\(ext)"
                    return FileData(data: data, fileName: fileName, mimeType: mime)
                }
                
                DispatchQueue.main.async {
                    self.request = RequestCreate(
                        dateFrom: dateFrom,
                        dateTo: dateTo,
                        confirmationType: confirmationType,
                        files: files
                    )
                    print("Updated request.dateTo: \(String(describing: self.request.dateTo))")
                    self.onRequestUpdated?()
                    self.validateFields()
                    
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
        print("DATETO _______ \(request.dateTo)")
    }

    
    func updateRequest() {
        Task {
            guard let dateFrom = request.dateFrom else {
                return
            }
            let dateFormatter = ISO8601DateFormatter()
            let dateFromString = dateFormatter.string(from: dateFrom)
            let dateToString = request.dateTo.map {dateFormatter.string(from: $0) }
            
            let confirmationType: ConfirmationType = {
                switch request.confirmationType {
                case .medical: return .medical
                case .family: return .family
                case .educational: return .educational
                }
            }()
            
            let multipartFiles = request.files.map {
                MultipartFile(
                    data: $0.data,
                    fileName: $0.fileName,
                    mimeType: $0.mimeType
                )
            }
            
            let requestDTO = RequestUpdateModel(
                dateFrom: dateFromString,
                dateTo: dateToString,
                files: multipartFiles
            )
            do {
                let response = try await updateRequestUseCase.execute(requestId: requestId!, request: requestDTO)
                DispatchQueue.main.async {
                    self.onSuccess?()
                    NotificationCenter.default.post(name: .requestAdded, object: nil)
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func createRequest() {
        Task {
            guard let dateFrom = request.dateFrom else {
                return
            }
            let dateFormatter = ISO8601DateFormatter()
            let dateFromString = dateFormatter.string(from: dateFrom)
            let dateToString = request.dateTo.map {dateFormatter.string(from: $0) }
            
            let confirmationType: ConfirmationType = {
                switch request.confirmationType {
                case .medical: return .medical
                case .family: return .family
                case .educational: return .educational
                }
            }()
            
            let multipartFiles = request.files.map {
                MultipartFile(
                    data: $0.data,
                    fileName: $0.fileName,
                    mimeType: $0.mimeType
                )
            }
            
            let requestDTO = RequestCreateDTO(
                dateFrom: dateFromString,
                dateTo: dateToString,
                confirmationType: confirmationType,
                files: multipartFiles
            )
            
            do {
                let response = try await createRequestUseCase.execute(request: requestDTO)
                DispatchQueue.main.async {
                    self.onSuccess?()
                    NotificationCenter.default.post(name: .requestAdded, object: nil)
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func guessFileType(from data: Data) -> (extension: String, mimeType: String) {
        guard data.count >= 4 else {
            return ("bin", "application/octet-stream")
        }
        
        let header = data.prefix(4)
        
        if header.starts(with: [0x25, 0x50, 0x44, 0x46]) {
            return ("pdf", "application/pdf")
        } else if header.starts(with: [0xFF, 0xD8, 0xFF]) {
            return ("jpg", "image/jpeg")
        } else if header.starts(with: [0x89, 0x50, 0x4E, 0x47]) {
            return ("png", "image/png")
        } else {
            return ("bin", "application/octet-stream")
        }
    }
}

extension AddRequestViewModel.Mode {
    var isEdit: Bool {
        if case .edit = self { return true }
        return false
    }
    
    var navigationTitle: String {
        switch self {
        case .create: return "Новая заявка"
        case .edit: return "Детали заявки"
        }
    }
}
