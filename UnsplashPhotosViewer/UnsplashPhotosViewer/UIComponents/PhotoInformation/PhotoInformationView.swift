//
//  PhotoInformationView.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 21/10/24.
//

import SwiftUI

// MARK: - Photo information wrapper

struct PhotoInformationView: UIViewRepresentable {
    
    let model: PhotoDetail
    let isLandscape: Bool
    
    func makeUIView(context: Context) -> PhotoInformation {
        return PhotoInformation()
    }
    
    func updateUIView(_ uiView: PhotoInformation, context: Context) {
        uiView.configure(with: model, isLandscape: isLandscape)
    }
}
