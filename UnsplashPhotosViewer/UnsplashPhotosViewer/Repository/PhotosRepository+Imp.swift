//
//  PhotosRepository+Imp.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 17/10/24.
//

import Foundation

// MARK: - Photos repository | Implementation

class PhotosRepositoryImp: PhotosRepository {
    
    func getPhotos(page: Int) async throws -> Photos {
        return try await ApiManager.shared.performRequest(for: .photos, and: page)
    }
    
    func getPhotoDetail(id: String, page: Int) async throws -> PhotoDetail {
        return try await ApiManager.shared.performRequest(for: .photoDetail(id: id), and: page)
    }
    
}
