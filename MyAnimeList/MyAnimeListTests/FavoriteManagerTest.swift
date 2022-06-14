//
//  FavoriteManagerTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
@testable import MyAnimeList

class FavoriteManagerTest: XCTestCase {

    func testAddAnime() {
        // Arrange
        FavoriteManager.clean()

        // Act
        FavoriteManager.add(.init(anime: .dummy))

        // Assert
        XCTAssertFalse(FavoriteManager.favoriteList.value.isEmpty)
        XCTAssertEqual(FavoriteManager.favoriteList.value.first,
                       FavoriteUnit.init(anime: .dummy))
        XCTAssertNotEqual(FavoriteManager.favoriteList.value.first,
                          FavoriteUnit.init(manga: .dummy))
    }

    func testAddManga() {
        // Arrange
        FavoriteManager.clean()

        // Act
        FavoriteManager.add(.init(manga: .dummy))

        // Assert
        XCTAssertFalse(FavoriteManager.favoriteList.value.isEmpty)
        XCTAssertNotEqual(FavoriteManager.favoriteList.value.first,
                       FavoriteUnit.init(anime: .dummy))
        XCTAssertEqual(FavoriteManager.favoriteList.value.first,
                          FavoriteUnit.init(manga: .dummy))
    }

    func testRemove() {
        // Arrange
        FavoriteManager.clean()
        FavoriteManager.add(.init(manga: .dummy))

        // Act
        FavoriteManager.remove(.init(manga: .dummy))

        // Assert
        XCTAssertTrue(FavoriteManager.favoriteList.value.isEmpty)
    }
}
