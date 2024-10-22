//
//  PhotosRepository+Mock.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 21/10/24.
//

import Foundation

// MARK: - Photos repository | Mock

class PhotosRepositoryMock: PhotosRepository {
    
    func getPhotos(page: Int) async throws -> Photos {
        guard let photos = PhotosRepositoryMock.getPhotosResponse() else {
            throw MockError.invalidRequest
        }
        return photos
    }
    
    func getPhotoDetail(for id: String) async throws -> PhotoDetail {
        guard let photoDetail = PhotosRepositoryMock.getPhotoDetail() else {
            throw MockError.invalidRequest
        }
        return photoDetail
    }
    
}

// MARK: - Mock responses

extension PhotosRepositoryMock {
    
    static func getPhotosResponse() -> Photos? {
        let responseString = """
        [
            {
                "id": "1",
                "urls": {
                    "raw": "https://example.com/photo1_raw.jpg",
                    "full": "https://example.com/photo1_full.jpg",
                    "regular": "https://example.com/photo1_regular.jpg",
                    "small": "https://example.com/photo1_small.jpg",
                    "thumb": "https://example.com/photo1_thumb.jpg"
                }
            },
            {
                "id": "2",
                "urls": {
                    "raw": "https://example.com/photo2_raw.jpg",
                    "full": "https://example.com/photo2_full.jpg",
                    "regular": "https://example.com/photo2_regular.jpg",
                    "small": "https://example.com/photo2_small.jpg",
                    "thumb": "https://example.com/photo2_thumb.jpg"
                }
            },
            {
                "id": "3",
                "urls": {
                    "raw": "https://example.com/photo3_raw.jpg",
                    "full": "https://example.com/photo3_full.jpg",
                    "regular": "https://example.com/photo3_regular.jpg",
                    "small": "https://example.com/photo3_small.jpg",
                    "thumb": "https://example.com/photo3_thumb.jpg"
                }
            }
        ]
        """
        let responseData = Data(responseString.utf8)
        
        return try? JSONDecoder().decode(Photos.self, from: responseData)
    }
    
    static func getPhotoDetail() -> PhotoDetail? {
        let responseString = """
        {
            "id": "1",
            "urls": {
                "raw": "https://example.com/photo1_raw.jpg",
                "full": "https://example.com/photo1_full.jpg",
                "regular": "https://example.com/photo1_regular.jpg",
                "small": "https://example.com/photo1_small.jpg",
                "thumb": "https://example.com/photo1_thumb.jpg"
            },
            "likes": 150,
            "downloads": 1200,
            "alt_description": "A beautiful sunset over the mountains"
        }
        """
        let responseData = Data(responseString.utf8)
        
        return try? JSONDecoder().decode(PhotoDetail.self, from: responseData)
    }
    
}
