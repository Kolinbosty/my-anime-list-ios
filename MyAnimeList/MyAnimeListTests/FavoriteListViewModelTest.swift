//
//  FavoriteListViewModelTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/14.
//

import XCTest
@testable import MyAnimeList

class FavoriteListViewModelTest: XCTestCase {

    func testCreateSnapshot() {
        // Arrange
        let vm = FavoriteListViewModel()
        let favs: [FavoriteUnit] = [
            .init(anime: .dummy),
            .init(manga: .dummy)
        ]

        // Act
        let snapshot = vm.createSnapshot(from: favs)

        // Assert
        XCTAssertEqual(snapshot.numberOfSections, 1)
        XCTAssertEqual(snapshot.numberOfItems, 2)
        XCTAssertEqual(snapshot.itemIdentifiers, favs)
    }
}
