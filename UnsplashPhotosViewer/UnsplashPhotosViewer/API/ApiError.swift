//
//  ApiError.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 16/10/24.
//

import Foundation

// MARK: - API Errors

enum ApiError: Error {
    case invalidUrl
    case invalidResponse
    case errorOnRequest
    case error(String)
}
