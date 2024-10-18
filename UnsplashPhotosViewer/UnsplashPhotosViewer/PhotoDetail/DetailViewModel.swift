//
//  DetailViewModel.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 18/10/24.
//

import SwiftUI

enum DetailState: Equatable {
    case idle
    case loadingPhoto
    case didLoadDetail(PhotoDetail)
    case error
}

@MainActor
class DetailViewModel: ObservableObject {
    
    @Published private(set) var state: DetailState = .idle
    
    private var repository: PhotosRepository
    
    init(repository: PhotosRepository = PhotosRepositoryImp()) {
        self.repository = repository
    }
    
}

// MARK: - Management

extension DetailViewModel {
    
    func getPhotoDetail(for id: String) {
        state = .loadingPhoto
        
        Task {
            do {
                let photoDetail = try await getPhotoDetail(for: id)
                
                state = .didLoadDetail(photoDetail)
            } catch {
                state = .error
            }
        }
    }
    
}

// MARK: - API Calls

private extension DetailViewModel {
    
    func getPhotoDetail(for id: String) async throws -> PhotoDetail {
        return try await repository.getPhotoDetail(for: id)
    }
    
}
