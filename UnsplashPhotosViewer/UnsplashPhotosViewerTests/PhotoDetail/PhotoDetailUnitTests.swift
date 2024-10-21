//
//  PhotoDetailUnitTests.swift
//  UnsplashPhotosViewerTests
//
//  Created by Martin Lago on 21/10/24.
//

import XCTest
@testable import UnsplashPhotosViewer

import Combine

final class PhotoDetailUnitTests: XCTestCase {
    
    private var viewModel: DetailViewModel!
    private var mockRepository: PhotosRepositoryMock!
    
    private var cancellables = Set<AnyCancellable>()
    private var receivedStates = [DetailState]()
    
    @MainActor override func setUp() {
        super.setUp()
        mockRepository = PhotosRepositoryMock()
        viewModel = DetailViewModel(repository: mockRepository)
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
    func testGetDetailSuccess() {
        guard let photoDetail = PhotosRepositoryMock.getPhotoDetail() else {
            return
        }
        
        let expectation = expectation(description: "Photo Detail successful initialization expectation.")
        let expectedStates: [DetailState] = [
            .idle,
            .loadingPhoto,
            .didLoadDetail(photoDetail)
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
        
        viewModel.getPhotoDetail(for: "foo")
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(expectedStates, receivedStates)
    }
    
}
