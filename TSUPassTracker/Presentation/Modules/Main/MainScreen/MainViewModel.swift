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
    
    var showAddRequest: (() -> Void)?
    var showEditRequest: ((String) -> Void)?
    
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
        let dateFormatterWithMilliseconds = ISO8601DateFormatter()
        dateFormatterWithMilliseconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let dateFormatterWithoutMilliseconds = ISO8601DateFormatter()
        dateFormatterWithoutMilliseconds.formatOptions = [.withInternetDateTime]

        func parseDate(_ dateString: String) -> Date? {
            return dateFormatterWithMilliseconds.date(from: dateString) ??
                   dateFormatterWithoutMilliseconds.date(from: dateString)
        }

        let lightRequests = userRequestsResponse.listLightRequests.map { dto -> LightRequest in
            let status = RequestStatusEntity(from: dto.status)
            let confirmationType =  ConfirmationTypeEntity(from: dto.confirmationType)

            let createdDate = parseDate(dto.createdDate) ?? Date()
            let dateFrom = parseDate(dto.dateFrom) ?? Date()
            let dateTo = dto.dateTo.flatMap { parseDate($0) }

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
            Date To: \(request.dateTo as Any)
            Status: \(request.status.rawValue)
            Confirmation Type: \(request.confirmationType.rawValue)
            -----------------------------
            """)
        }

        return mappedList
    }

    
    
    
    func editRequest(id: String) {
        print("Редактирование запроса с ID: \(id)")
        DispatchQueue.main.async {
            self.showEditRequest?(id)
        }
    }
    
    func addNote() {
        print("Добавление новой заявки")
        DispatchQueue.main.async {
            self.showAddRequest?()
        }
    }
}
