//
//  HomeUnitTests.swift
//  UnsplashPhotosViewerTests
//
//  Created by Martin Lago on 21/10/24.
//

import XCTest
@testable import UnsplashPhotosViewer

import Combine

final class HomeUnitTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var mockRepository: PhotosRepositoryMock!
    
    private var cancellables = Set<AnyCancellable>()
    private var receivedStates = [HomeState]()
    
    @MainActor override func setUp() {
        super.setUp()
        mockRepository = PhotosRepositoryMock()
        viewModel = HomeViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        receivedStates = []
        cancellables = []
        super.tearDown()
    }
    
    // Test case to check if `initialization` updates state correctly
    @MainActor
    func testInitializationSuccess() {
        let photos = PhotosRepositoryMock.getPhotosResponse() ?? []
        
        let expectation = expectation(description: "Home successful initialization expectation.")
        let expectedStates: [HomeState] = [
            .idle,
            .loadingPhotos,
            .didLoadPhotos(photos)
        ]
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { state in
                self.receivedStates.append(state)
                if self.receivedStates.count == expectedStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.initialization()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(expectedStates, receivedStates)
    }
    
    // Test case to check the load of more photos when scrolling in the grid
    @MainActor
    func testLoadMorePhotosSuccess() {
        let photos = PhotosRepositoryMock.getPhotosResponse() ?? []
        
        let expectation = expectation(description: "Load more photos in Home expectation.")
        let expectedStates: [HomeState] = [
            .idle,
            .loadingMorePhotos,
            .didLoadPhotos(photos)
        ]
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { state in
                self.receivedStates.append(state)
                if self.receivedStates.count == expectedStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadMorePhotos(for: 4)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(expectedStates, receivedStates)
    }
    
}
