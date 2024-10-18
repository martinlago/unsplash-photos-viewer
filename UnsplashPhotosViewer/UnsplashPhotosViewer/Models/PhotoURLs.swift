//
//  PhotoURLs.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 17/10/24.
//

import Foundation

// MARK: - Photo URLs

struct PhotoURLs: Decodable, Equatable, Hashable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
