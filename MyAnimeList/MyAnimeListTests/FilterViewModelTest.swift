//
//  FilterViewModelTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
@testable import MyAnimeList

class FilterViewModelTest: XCTestCase {

    func testFilterViewModel() {
        // Arrange
        let rawData: [FilterViewModel.SectionRawData] = [
            ("TypeA", ["a", "b", "c"])
        ]
        let selection = ["TypeA": ["a"]]

        // Action
        let vm = FilterViewModel(sections: rawData, defaultSelection: selection)
        let sectionName = vm.selectionsData.first?.name
        let cellVMs = vm.selectionsData.first?.selections
        let aCell = cellVMs?.first
        let cCell = cellVMs?.last

        // Assert
        XCTAssertEqual(sectionName, "TypeA")
        XCTAssertEqual(cellVMs?.count ?? 0, 3)
        XCTAssertEqual(aCell?.name, "a")
        XCTAssertTrue(aCell?.isSelected ?? false)
        XCTAssertEqual(cCell?.name, "c")
        XCTAssertFalse(cCell?.isSelected ?? true)
    }
}
