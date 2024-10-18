
//  HomeView.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 17/10/24.
//

import SwiftUI

// MARK: - Main view

struct HomeView: View {
    
    /// ViewModel
    @StateObject var viewModel = HomeViewModel()
    
    /// State
    @State private var isLoading = true
    @State private var photos: Photos = []
    @State private var currentPage = 1
    @State private var columnsNumber = 2
        
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        CustomGrid(columns: columnsNumber, horizontalSpacing: 24, verticalSpacing: 24) {
                            ForEach(photos) { photo in
                                imageView(url: photo.urls.thumb)
                                    .id(photo.id)
                            }
                        }
                        .padding(4)
                    }
                    .scrollIndicators(.never)
                    .onChange(of: columnsNumber) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(photos.first?.id, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .task {
            getColumnsNumber()
            viewModel.initialization()
        }
        .onReceive(viewModel.$state, perform: evaluateState)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            getColumnsNumber()
        }
    }
}

// MARK: - Views

private extension HomeView {
    
    func imageView(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image
        } placeholder: {
            ProgressView()
        }
    }
    
}

// MARK: - Helpers

private extension HomeView {
    
    func evaluateState(_ state: HomeState) {
        switch state {
        case .idle:
            isLoading = true
        case .loadingPhotos:
            isLoading = true
        case .didLoadPhotos(let photos):
            self.photos = photos
            isLoading = false
        case .error:
            isLoading = false
            // TODO: Define error case behavior
        }
    }
    
    func getColumnsNumber() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            columnsNumber = 4
        default:
            columnsNumber = 2
        }
    }
    
}

#Preview {
    HomeView()
}
