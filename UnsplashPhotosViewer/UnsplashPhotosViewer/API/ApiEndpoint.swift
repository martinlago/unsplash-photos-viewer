//
//  ApiEndpoint.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 16/10/24.
//

import Foundation

// MARK: - API Endpoints

enum ApiEndpoint {
    case photos
    case photoDetail(id: String)
    
    var method: String {
        switch self {
        case .photos, .photoDetail:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .photos:
            "photos"
        case .photoDetail(let id):
            "photos/\(id)"
        }
    }
}
