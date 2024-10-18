//
//  HomeViewModel.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 17/10/24.
//

import SwiftUI

enum HomeState: Equatable {
    case idle
    case loadingPhotos
    case didLoadPhotos(Photos)
    case error
}

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published private(set) var state: HomeState = .idle
    
    private var repository: PhotosRepository
    
    init(repository: PhotosRepository = PhotosRepositoryImp()) {
        self.repository = repository
    }
    
}

// MARK: - Management

extension HomeViewModel {
    
    func initialization() {
        state = .loadingPhotos
        
        Task {
            do {
                let photos = try await getPhotos()
                
                state = .didLoadPhotos(photos)
            } catch {
                state = .error
            }
        }
    }
    
}

// MARK: - API Calls

private extension HomeViewModel {
    
    func getPhotos() async throws -> Photos {
        return try await repository.getPhotos(page: 1)
    }
    
}
