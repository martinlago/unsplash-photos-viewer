//
//  HomeUnitTestsError.swift
//  UnsplashPhotosViewerTests
//
//  Created by Martin Lago on 21/10/24.
//

import XCTest
@testable import UnsplashPhotosViewer

import Combine

final class HomeUnitTestsError: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var mockRepository: PhotosRepositoryMockError!
    
    private var cancellables = Set<AnyCancellable>()
    private var receivedStates = [HomeState]()
    
    @MainActor override func setUp() {
        super.setUp()
        mockRepository = PhotosRepositoryMockError()
        viewModel = HomeViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        receivedStates = []
        cancellables = []
        super.tearDown()
    }
    
    // Test case to check if `initialization` updates state correctly when the API call fails
    @MainActor
    func testInitializationError() {
        let expectation = expectation(description: "Home unsuccessful initialization expectation.")
        let expectedStates: [HomeState] = [
            .idle,
            .loadingPhotos,
            .error
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
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(expectedStates, receivedStates)
    }
    
    // Test case to check the load of more photos when scrolling in the grid
    @MainActor
    func testLoadMorePhtoosError() {
        let photos = PhotosRepositoryMock.getPhotosResponse() ?? []
        
        let expectation = expectation(description: "Load more photos error expectation.")
        let expectedStates: [HomeState] = [
            .idle,
            .loadingMorePhotos,
            .error
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
        
        viewModel.loadMorePhotos(for: 3)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(expectedStates, receivedStates)
    }
    
}

