//
//  PhotoDetail.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 16/10/24.
//

import Foundation

// MARK: - Photo detail model

struct PhotoDetail: Decodable {
    let id: String
    let urls: PhotoURLs
    let likes: Int
    let downloads: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, urls, likes, downloads
        case description = "alt_description"
    }
}
