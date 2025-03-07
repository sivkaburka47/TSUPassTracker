//
//  AlamofireHTTPClient.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

import Alamofire
import KeychainAccess
import Foundation

final class AlamofireHTTPClient: HTTPClient {
    
    private let baseURL: BaseURL
    let keychain = Keychain()
    
    init(baseURL: BaseURL) {
        self.baseURL = baseURL
    }
    
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws -> T {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response() { response in
                    self.log(response)
                }
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        continuation.resume(returning: decodedData)
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 500 {
                                continuation.resume(throwing: NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Упс, проблема с состоянием сервера."]))
                                return
                            }
                            if statusCode == 401 {
                                self.handleUnauthorizedError()
                                continuation.resume(throwing: error)
                                return
                            }
                        }
                        
                        if let afError = error.asAFError, afError.isSessionTaskError,
                           let underlyingError = afError.underlyingError as NSError?,
                           underlyingError.domain == NSURLErrorDomain,
                           underlyingError.code == -1004 {
                            continuation.resume(throwing: NSError(domain: "", code: -1004, userInfo: [NSLocalizedDescriptionKey: "Не удалось подключиться к серверу. Проверьте подключение к интернету или попробуйте позже."]))
                            return
                        }
                        
                        if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            let errorMessage = self.extractErrorMessage(from: errorResponse)
                            continuation.resume(throwing: NSError(domain: "", code: errorResponse.status, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
    
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 500 {
                                continuation.resume(throwing: NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Упс, проблема с состоянием сервера."]))
                                return
                            }
                            if statusCode == 401 {
                                self.handleUnauthorizedError()
                                continuation.resume(throwing: error)
                                return
                            }
                        }
                        
                        if let afError = error.asAFError, afError.isSessionTaskError,
                           let underlyingError = afError.underlyingError as NSError?,
                           underlyingError.domain == NSURLErrorDomain,
                           underlyingError.code == -1004 {
                            continuation.resume(throwing: NSError(domain: "", code: -1004, userInfo: [NSLocalizedDescriptionKey: "Не удалось подключиться к серверу. Проверьте подключение к интернету или попробуйте позже."]))
                            return
                        }
                        
                        if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            let errorMessage = self.extractErrorMessage(from: errorResponse)
                            continuation.resume(throwing: NSError(domain: "", code: errorResponse.status, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
    
    private func extractErrorMessage(from errorResponse: ErrorResponse) -> String {
        if let message = errorResponse.message {
            return message
        } else if let errors = errorResponse.errors {
            let errorMessages = errors.flatMap { $0.value }.joined(separator: "\n")
            return errorMessages
        } else if let title = errorResponse.title {
            return title
        } else {
            return "Произошла неизвестная ошибка."
        }
    }
    
    private func handleUnauthorizedError() {
        do {
            try keychain.remove("authToken")
        } catch {
            print("Ошибка удаления токена: \(error)")
        }
        
        NotificationCenter.default.post(name: .unauthorizedErrorOccurred, object: nil)
    }
}

// MARK: Requests logging
private extension AlamofireHTTPClient {
    func log(_ response: AFDataResponse<Data?>) {
        print("---------------------------------------------------------------------------------------")
        print("\(response.request?.method?.rawValue ?? SC.empty) \(response.request?.url?.absoluteString ?? SC.empty)")
        print("---------------------------------------------------------------------------------------")
        
        switch response.result {
            
        case let .success(responseData):
            if let object = try? JSONSerialization.jsonObject(with: responseData ?? .empty),
               let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
               let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print(string)
            }
        case let .failure(error):
            print(error)
        }
        print("---------------------------------------------------------------------------------------")
    }
}
