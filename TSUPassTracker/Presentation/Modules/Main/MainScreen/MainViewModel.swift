//
//  MainViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import Foundation

final class MainScreenViewModel {
    
    private let getUserAllRequestsUseCase: GetUserAllRequestsUseCase
    
    var userRequests = ListLightRequests()
    
    var onDidLoadUserRequests: ((ListLightRequests) -> Void)?
    
    init() {
        self.getUserAllRequestsUseCase = GetUserAllRequestsUseCaseImpl.create()
    }
    
    func onDidLoad() {
        Task {
            do {
                userRequests = try await fetchUserRequests()
                onDidLoadUserRequests?(userRequests)
            } catch let error as NSError {
            }
        }
    }
    
    
    private func fetchUserRequests() async throws -> ListLightRequests {
        do {
            let userRequestsResponse = try await getUserAllRequestsUseCase.execute()
            return mapToListLightRequests(userRequestsResponse)
        } catch {
            throw error
        }
    }
    
    func mapToListLightRequests(_ userRequestsResponse: ListLightRequestsDTO) -> ListLightRequests {
        let dateFormatter = ISO8601DateFormatter()
        
        let lightRequests = userRequestsResponse.listLightRequests.map { dto -> LightRequest in
            let status = RequestStatusEntity(rawValue: dto.status.rawValue) ?? .pending
            let confirmationType = ConfirmationTypeEntity(rawValue: dto.confirmationType.rawValue) ?? .family
            
            let createdDate = dateFormatter.date(from: dto.createdDate) ?? Date()
            let dateFrom = dateFormatter.date(from: dto.dateFrom) ?? Date()
            let dateTo = dto.dateTo.flatMap { dateFormatter.date(from: $0) }
            
            return LightRequest(
                id: dto.id,
                createdDate: createdDate,
                dateFrom: dateFrom,
                dateTo: dateTo,
                userName: dto.userName,
                status: status,
                confirmationType: confirmationType
            )
        }
        
        let mappedList = ListLightRequests(listLightRequests: lightRequests)
        print("=== Mapped User Requests ===")
        for request in mappedList.listLightRequests {
            print("""
            -----------------------------
            ID: \(request.id)
            User: \(request.userName)
            Created: \(request.createdDate)
            Date From: \(request.dateFrom)
            Date To: \(request.dateTo)
            Status: \(request.status.rawValue)
            Confirmation Type: \(request.confirmationType.rawValue)
            -----------------------------
            """)
        }
        
        return mappedList
    }
    
    
    
    func editRequest(id: String) {
        print("Редактирование запроса с ID: \(id)")
        // Перенаправление на модальный экран редактирования заявки
    }
    
    func saveFiles(id: String) {
        print("Скачивание файлов для запроса с ID: \(id)")
        // Логика скачивания
    }
    
    func addNote() {
        print("Добавление новой заявки")
        // Перенаправление на модальный экран добавления заявки
    }
}
