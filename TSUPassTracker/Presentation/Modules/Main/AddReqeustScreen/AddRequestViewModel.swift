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

final class AddRequestViewModel {
    var request = RequestCreate()
    var files: [FileData] = []
    
    private let createRequestUseCase: CreateRequestUseCase
    
    var isAddButtonActive: ((Bool) -> Void)?
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init() {
        self.createRequestUseCase = CreateRequestUseCaseImpl.create()
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
}
