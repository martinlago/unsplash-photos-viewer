//
//  PhotosRepository+MockError.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 21/10/24.
//

import Foundation

enum MockError: Error {
    case invalidRequest
}

// MARK: - Photos repository | Mock errors

class PhotosRepositoryMockError: PhotosRepository {
    
    func getPhotos(page: Int) async throws -> Photos {
        throw MockError.invalidRequest
    }
    
    func getPhotoDetail(for id: String) async throws -> PhotoDetail {
        throw MockError.invalidRequest
    }
    
}
