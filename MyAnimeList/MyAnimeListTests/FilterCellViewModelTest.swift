//
//  FilterCellViewModelTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
import Combine
@testable import MyAnimeList

class FilterCellViewModelTest: XCTestCase {

    private var cancellables: Set<AnyCancellable> = .init()

    func testFilterCellVM() {
        // Arrange
        var firstImg: UIImage?
        var secondImg: UIImage?
        let vm = FilterCellViewModel(name: "aaa", isSelected: false)
        vm.iconPublisher
            .prefix(1)
            .sink { img in
                firstImg = img
            }
            .store(in: &cancellables)

        vm.iconPublisher
            .dropFirst()
            .sink { img in
                secondImg = img
            }
            .store(in: &cancellables)

        // Act
        vm.isSelected = true

        // Assert
        XCTAssertNotNil(firstImg)
        XCTAssertNotNil(secondImg)
        XCTAssertNotEqual(firstImg, secondImg)
    }
}
