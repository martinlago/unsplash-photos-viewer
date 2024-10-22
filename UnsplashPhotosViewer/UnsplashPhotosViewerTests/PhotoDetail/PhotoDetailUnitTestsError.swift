//
//  PhotoDetailUnitTestsError.swift
//  UnsplashPhotosViewerTests
//
//  Created by Martin Lago on 21/10/24.
//

import XCTest
@testable import UnsplashPhotosViewer

import Combine

final class DetailUnitTestsError: XCTestCase {
    
    private var viewModel: DetailViewModel!
    private var mockRepository: PhotosRepositoryMockError!
    
    private var cancellables = Set<AnyCancellable>()
    private var receivedStates = [DetailState]()
    
    @MainActor override func setUp() {
        super.setUp()
        mockRepository = PhotosRepositoryMockError()
        viewModel = DetailViewModel(repository: mockRepository)
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
    func testGetDetailError() {
        let expectation = expectation(description: "Photo Detail unsuccessful initialization expectation.")
        let expectedStates: [DetailState] = [
            .idle,
            .loadingPhoto,
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
        
        viewModel.getPhotoDetail(for: "bar")
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(expectedStates, receivedStates)
    }
    
}
