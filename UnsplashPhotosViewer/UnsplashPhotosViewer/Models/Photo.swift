//
//  Photo.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 16/10/24.
//

import Foundation

// MARK: - Photos models

typealias Photos = [Photo]

struct Photo: Decodable, Equatable, Identifiable, Hashable {
    let id: String
    let urls: PhotoURLs
}

extension Photo {
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
}
