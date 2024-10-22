//
//  ApiManager.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 16/10/24.
//

import Foundation

// MARK: - API Manager

class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    func performRequest<D: Decodable>(
        to url: String = ApiConstants.baseURL,
        for endpoint: ApiEndpoint,
        and page: Int = 1
    ) async throws -> D {
        let request = try createRequest(to: url, for: endpoint, and: page)
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        if let response = try? JSONDecoder().decode(D.self, from: responseData) {
            return response
        } else {
            throw ApiError.invalidResponse
        }
    }

}

// MARK: - Helpers

private extension ApiManager {
    
    func createRequest(to urlString: String, for endpoint: ApiEndpoint, and page: Int) throws -> URLRequest {
        guard let url = URL(string: urlString),
              var components = URLComponents(url: url.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true),
              let clientId = ProcessInfo.processInfo.environment[AppConstants.unsplashAccessKey]
        else {
            throw ApiError.invalidUrl
        }
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(15)),
        ]
        var request = URLRequest(url: components.url!)
        
        /// Method
        request.httpMethod = endpoint.method
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
                
        return request
    }
    
}
