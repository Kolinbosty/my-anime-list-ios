//
//  FilterUnitTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
@testable import MyAnimeList

enum TestFilterUnit: String, CaseIterable, FilterUnit, Equatable {
    static var filterSectionName: String { "Test" }

    case a
    case b
    case c
}

class FilterUnitTest: XCTestCase {

    func testFilterUnit() {
        // Arrange
        let expectCasesStr: [String] = TestFilterUnit.allCases.map(\.rawValue)
        let expectSectionName = "Test"
        let expectFilterData = (expectSectionName, expectCasesStr)
        let possibleQueryString: [String] = [
            "a,b,c",
            "a,c,b",
            "b,a,c",
            "b,c,a",
            "c,a,b",
            "c,b,a",
        ]

        // Act
        let casesStr = TestFilterUnit.allCasesString
        let sectionName = TestFilterUnit.filterSectionName
        let filterData = TestFilterUnit.allCasesFilterData
        let queryStr = Set(TestFilterUnit.allCases).convertToQueryString!

        // Assert
        XCTAssertEqual(casesStr, expectCasesStr)
        XCTAssertEqual(sectionName, expectSectionName)
        XCTAssertEqual(filterData.0, expectFilterData.0)
        XCTAssertEqual(filterData.1, expectFilterData.1)
        XCTAssertTrue(possibleQueryString.contains(queryStr))
    }

    func testAnimeTypeName() {
        // Arrange
        let expectSectionName = "Type"

        // Act
        let sectionName = AnimePagingHandler.AnimeType.filterSectionName

        // Assert
        XCTAssertEqual(sectionName, expectSectionName)
    }

    func testAnimeFilterName() {
        // Arrange
        let expectSectionName = "Filter"

        // Act
        let sectionName = AnimePagingHandler.AnimeFilter.filterSectionName

        // Assert
        XCTAssertEqual(sectionName, expectSectionName)
    }

    func testMangaTypeName() {
        // Arrange
        let expectSectionName = "Type"

        // Act
        let sectionName = MangaPagingHandler.MangaType.filterSectionName

        // Assert
        XCTAssertEqual(sectionName, expectSectionName)
    }

    func testMangaFilterName() {
        // Arrange
        let expectSectionName = "Filter"

        // Act
        let sectionName = MangaPagingHandler.MangaFilter.filterSectionName

        // Assert
        XCTAssertEqual(sectionName, expectSectionName)
    }

    func testCreateMangaCellViewModel() {
        // Arrange
        let unit = FavoriteUnit(manga: .dummy)

        // Act
        let vm = unit.listCellViewModel

        // Assert
        XCTAssertNotNil(vm as? MangaCellViewModel)
    }

    func testCreateAnimeCellViewModel() {
        // Arrange
        let unit = FavoriteUnit(anime: .dummy)

        // Act
        let vm = unit.listCellViewModel

        // Assert
        XCTAssertNotNil(vm as? AnimeCellViewModel)
    }
}
