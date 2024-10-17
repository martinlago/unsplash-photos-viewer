//
//  Photo.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 16/10/24.
//

import Foundation

// MARK: - Photos models

typealias Photos = [Photo]

struct Photo: Decodable {
    let id: String
    let urls: PhotoURLs
}
