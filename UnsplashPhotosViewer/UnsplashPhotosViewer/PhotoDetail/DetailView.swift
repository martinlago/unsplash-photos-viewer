//
//  DetailView.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 18/10/24.
//

import SwiftUI

// MARK: - Photo Detail view

struct DetailView: View {
    
    /// ViewModel and router
    @StateObject var viewModel = DetailViewModel()
    
    /// Parameters
    @Binding var photoId: String
    let photosIds: [String]
    let isLandscape: Bool
    
    /// State variables
    @State private var isLoading = true
    @State private var detail: PhotoDetail?
    
    var body: some View {
        TabView(selection: $photoId) {
            ForEach(photosIds, id: \.self) { index in
                ZStack {
                    if isLoading {
                        ProgressView("Loading photo...")
                    } else if let detail = detail {
                        detailView(for: detail)
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .animation(.easeInOut, value: photoId)
        .onAppear {
            viewModel.getPhotoDetail(for: photoId)
        }
        .onChange(of: photoId) {
            viewModel.getPhotoDetail(for: photoId)
        }
        .onReceive(viewModel.$state, perform: evaluateState)
    }
}

// MARK: - View helpers

private extension DetailView {
    
    @ViewBuilder
    func detailView(for detail: PhotoDetail) -> some View {
        GeometryReader { geometry in
            if isLandscape {
                HStack {
                    image(for: detail.urls.small)
                        .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height)
                    PhotoInformationView(model: detail, isLandscape: isLandscape)
                        .frame(width: geometry.size.width / 2 - 24, height: geometry.size.height)
                }
            } else {
                ZStack {
                    image(for: detail.urls.regular)
                        .frame(maxHeight: geometry.size.height - 200)
                    PhotoInformationView(model: detail, isLandscape: isLandscape)
                }
            }
        }
    }
    
    func image(for url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView("Loading photo...")
        }

    }
    
}

// MARK: - Helpers

private extension DetailView {
    
    func evaluateState(_ state: DetailState) {
        switch state {
        case .idle:
            break
        case .loadingPhoto:
            isLoading = true
        case .didLoadDetail(let photoDetail):
            detail = photoDetail
            isLoading = false
        case .error:
            isLoading = false
            // TODO: Define error case behavior
        }
    }
    
}

#Preview {
    DetailView(photoId: .constant("123"), photosIds: [], isLandscape: false)
}
