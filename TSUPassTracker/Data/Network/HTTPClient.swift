//
//  HTTPClient.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 07.03.2025.
//

protocol HTTPClient {
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws -> T
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws
}

