
//  HomeView.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 17/10/24.
//

import SwiftUI

// MARK: - Main view

struct HomeView: View {
    
    /// ViewModel and router
    @StateObject var viewModel = HomeViewModel()
    @StateObject var router: Router<HomeRoute> = Router()
    
    /// State
    @State private var isLoading = true
    @State private var isLoadingMorePhotos = true
    @State private var photos: Photos = []
    @State private var currentPage = 1
    @State private var columnsNumber = 2
    @State private var selectedPhotoId: String = ""
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                if isLoading {
                    ProgressView("Loading photos...")
                } else {
                    ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                            LazyVStack {
                                CustomGrid(columns: columnsNumber, horizontalSpacing: 16, verticalSpacing: 16) {
                                    ForEach(photos) { photo in
                                        imageView(photo: photo)
                                            .id(photo.id)
                                    }
                                }
                                .padding(4)
                                .frame(minHeight: UIScreen.main.bounds.height + 100)
                                
                                loadingMoreImagesView
                            }
                            .scrollIndicators(.never)
                            .onChange(of: selectedPhotoId) {
                                scrollGrid(in: proxy, for: selectedPhotoId)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .detail:
                    DetailView(
                        photoId: $selectedPhotoId,
                        photosIds: photos.map { $0.id },
                        isLandscape: columnsNumber == 4
                    )
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
    
    func imageView(photo: Photo) -> some View {
        AsyncImage(url: URL(string: photo.urls.thumb)) { image in
            image
                .resizable()
                .frame(width: (UIScreen.main.bounds.width / CGFloat(columnsNumber)) - (columnsNumber == 4 ? 32 : 12))
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 32))
        } placeholder: {
            ProgressView()
        }
        .onTapGesture {
            selectPhoto(with: photo.id)
        }
    }
    
    @ViewBuilder
    var loadingMoreImagesView: some View {
        ZStack {
            ProgressView()
        }
        .onAppear {
            loadMoreImages()
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
            withAnimation {
                self.photos += photos
            }
            isLoading = false
            isLoadingMorePhotos = false
        case .loadingMorePhotos:
            isLoadingMorePhotos = true
        case .error:
            // TODO: Define error case behavior
            isLoading = false
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
    
    func selectPhoto(with id: String) {
        selectedPhotoId = id
        router.push(.detail)
    }
    
    func scrollGrid(in proxy: ScrollViewProxy, for id: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                proxy.scrollTo(id, anchor: .top)
            }
        }
    }
    
    func loadMoreImages() {
        currentPage += 1
        viewModel.loadMorePhotos(for: currentPage)
    }
    
}

#Preview {
    HomeView()
}
