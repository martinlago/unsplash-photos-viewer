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
    @ObservedObject var router: Router<HomeRoute>
    @Binding var photoId: String
    let photosIds: [String]
    
    /// State variables
    @State private var isLoading = true
    @State private var detail: PhotoDetail?
    
    var body: some View {
        TabView(selection: $photoId) {
            ForEach(photosIds, id: \.self) { index in
                if let detail = detail {
                    GeometryReader { geometry in
                        VStack(alignment: .center, spacing: 24) {
                            Text(detail.description)
                            
                            AsyncImage(url: URL(string: detail.urls.regular)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: geometry.size.height - 180)
                            } placeholder: {
                                ProgressView()
                            }
                        }
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
    DetailView(
        router: Router(),
        photoId: .constant("123"),
        photosIds: []
    )
}
