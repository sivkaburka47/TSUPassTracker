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
    
    // MARK: - Public Methods
    
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
                        let handledError = self.handleError(
                            statusCode: response.response?.statusCode,
                            data: response.data,
                            error: error
                        )
                        continuation.resume(throwing: handledError)
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
                        let handledError = self.handleError(
                            statusCode: response.response?.statusCode,
                            data: response.data,
                            error: error
                        )
                        continuation.resume(throwing: handledError)
                    }
                }
        }
    }
    
    func sendMultipartRequest<T: Decodable>(endpoint: APIEndpoint, multipartData: RequestCreateDTO) async throws -> T {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    self.configureMultipartData(multipartFormData, with: multipartData)
                },
                to: url,
                method: method,
                headers: headers
            )
            .validate()
            .response() { response in
                self.log(response)
            }
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedData):
                    continuation.resume(returning: decodedData)
                case .failure(let error):
                    let handledError = self.handleError(
                        statusCode: response.response?.statusCode,
                        data: response.data,
                        error: error
                    )
                    continuation.resume(throwing: handledError)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleError(statusCode: Int?, data: Data?, error: Error) -> NSError {
        if let statusCode = statusCode {
            switch statusCode {
            case 500:
                return NSError(
                    domain: "",
                    code: statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Упс, проблема с состоянием сервера."]
                )
            case 401:
                handleUnauthorizedError()
                return NSError(
                    domain: "",
                    code: statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Упс, неверный логин или пароль.\nПопробуйте снова.."]
                )
            default:
                break
            }
        }
        
        if let afError = error.asAFError,
           afError.isSessionTaskError,
           let underlyingError = afError.underlyingError as NSError?,
           underlyingError.domain == NSURLErrorDomain,
           underlyingError.code == -1004 {
            return NSError(
                domain: "",
                code: -1004,
                userInfo: [NSLocalizedDescriptionKey: "Не удалось подключиться к серверу. Проверьте подключение к интернету или попробуйте позже."]
            )
        }
        
        if let data = data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            let errorMessage = extractErrorMessage(from: errorResponse)
            return NSError(
                domain: "",
                code: errorResponse.status,
                userInfo: [NSLocalizedDescriptionKey: errorMessage]
            )
        }
        
        return error as NSError
    }
    
    private func configureMultipartData(_ formData: MultipartFormData, with data: RequestCreateDTO) {
        formData.append(
            data.dateFrom.data(using: .utf8)!,
            withName: "DateFrom",
            mimeType: "text/plain"
        )
        
        if let dateTo = data.dateTo {
            formData.append(
                Data(dateTo.utf8),
                withName: "DateTo",
                mimeType: "text/plain"
            )
        }
        
        let typeString = data.confirmationType.rawValue
        formData.append(
            Data(typeString.utf8),
            withName: "ConfirmationType",
            mimeType: "text/plain"
        )
        
        for file in data.files {
            formData.append(
                file.data,
                withName: "Files",
                fileName: file.fileName,
                mimeType: file.mimeType
            )
        }
    }
    
    private func extractErrorMessage(from errorResponse: ErrorResponse) -> String {
        if let message = errorResponse.message {
            return message
        } else if let errors = errorResponse.errors {
            return errors.flatMap { $0.value }.joined(separator: "\n")
        } else if let title = errorResponse.title {
            return title
        }
        return "Произошла неизвестная ошибка."
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

// MARK: - Request Logging
private extension AlamofireHTTPClient {
    func log(_ response: AFDataResponse<Data?>) {
        print("---------------------------------------------------------------------------------------")
        print("\(response.request?.method?.rawValue ?? "") \(response.request?.url?.absoluteString ?? "")")
        print("---------------------------------------------------------------------------------------")
        
        switch response.result {
        case .success(let responseData):
            if let data = responseData,
               let object = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
               let string = String(data: prettyData, encoding: .utf8) {
                print(string)
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
        print("---------------------------------------------------------------------------------------")
    }
}
