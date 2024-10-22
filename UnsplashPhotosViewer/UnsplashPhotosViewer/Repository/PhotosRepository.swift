//
//  File.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 16/10/24.
//

import Foundation

// MARK: - Photos repository protocol

protocol PhotosRepository {
    func getPhotos(page: Int) async throws -> Photos
    func getPhotoDetail(for id: String) async throws -> PhotoDetail
}
