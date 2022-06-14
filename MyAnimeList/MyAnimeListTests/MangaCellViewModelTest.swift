//
//  MangaCellViewModelTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
import Combine
@testable import MyAnimeList

class MangaCellViewModelTest: XCTestCase {

    private var cancellables: Set<AnyCancellable> = .init()

    func testBaseCellItems() {
        // Arrange
        let manga = MangaData.dummy
        let vm = MangaCellViewModel(data: manga, page: 0)

        var heartImg: UIImage? = nil
        var title: String? = nil
        var periodText: String? = nil
        var rankText: String? = nil
        var photoURL: URL? = nil

        // Act
        vm.listTitle
            .sink { title = $0 }
            .store(in: &cancellables)

        vm.listHeartIcon
            .sink { heartImg = $0 }
            .store(in: &cancellables)

        vm.listRankText
            .sink { rankText = $0 }
            .store(in: &cancellables)

        vm.listPeriodText
            .sink { periodText = $0 }
            .store(in: &cancellables)

        vm.listPhotoURL
            .sink { photoURL = $0 }
            .store(in: &cancellables)

        // Assert
        XCTAssertEqual(title, "Title: manga")
        XCTAssertEqual(heartImg, UIImage.sf_heart)
        XCTAssertEqual(rankText, "Rank: 1")
        XCTAssertEqual(periodText, "2009-03-17 ~ ")
        XCTAssertEqual(photoURL?.absoluteString, "http://google.com")
    }

    func testFavoriteTap() {
        // Arrange
        FavoriteManager.clean()
        let manga = MangaData.dummy
        let vm = MangaCellViewModel(data: manga, page: 0)

        // TEST ADD //
        // Act
        vm.handleHeartTapped()

        // Assert
        XCTAssertTrue(FavoriteManager.isMangaFavorite(manga))

        // TEST REMOVE //
        // Act
        vm.handleHeartTapped()

        // Assert
        XCTAssertFalse(FavoriteManager.isMangaFavorite(manga))
    }
}
