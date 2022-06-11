//
//  PagingHandlerTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import XCTest
import Combine
@testable import MyAnimeList

struct TestPagingUnit: PagingUnit {
    let page: Int
    let value: String

    var pagingIdentifier: AnyHashable { page }
}

class TestPagingHandler: PagingHandler<TestPagingUnit> {

    override init() {
        super.init()

        // Setup provider
        itemsProvider = { lastItem in
            // Create dummy data
            let nextPage = (lastItem?.page ?? -1) + 1
            let nextList = (0..<10).map { index in
                return TestPagingUnit(page: nextPage, value: "\(nextPage)-\(index)")
            }

            return Just((nextList, nextPage < 4))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

class PagingHandlerTest: XCTestCase {

    /// 測試有收到 Fetching 狀態。
    func testFetchingSignal() {
        // Arrange
        let handler = TestPagingHandler()
        let expectation = XCTestExpectation(description: "Test")
        let cancellable = handler.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .fetching:
                    XCTAssertTrue(true)
                    expectation.fulfill()
                default: ()
                }
            }

        // Act
        handler.fetchNext()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // Force retain
            cancellable.cancel()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    /// 測試有收到 Reloading 狀態。
    func testReloadSignal() {
        // Arrange
        let handler = TestPagingHandler()
        let expectation = XCTestExpectation(description: "Test")
        let cancellable = handler.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .reloading:
                    XCTAssertTrue(true)
                    expectation.fulfill()
                default: ()
                }
            }

        // Act
        handler.reload()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // Force retain
            cancellable.cancel()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    /// 測試 Fetch 後數量是否正確。
    func testFetchSuccess() {
        // Arrange
        let handler = TestPagingHandler()
        let expectation = XCTestExpectation(description: "Test")

        // Act
        handler.fetchNext()

        // Assert
        handler.pagingQueue.async {
            XCTAssertTrue(handler.list.count == 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    /// 測試 Fetch 超過最大頁面數量次，不會影響資料，並且不會多打 API。
    func testFetchReachEnd() {
        // Arrange
        let handler = TestPagingHandler()
        let expectation = XCTestExpectation(description: "Test")
        var fetchingCount = 0
        let cancellable = handler.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .fetching:
                    fetchingCount += 1
                default: ()
                }
            }

        // Act
        (0..<10).forEach { _ in
            handler.fetchNext()
        }

        // Assert
        handler.pagingQueue.async {
            XCTAssertFalse(handler.hasNextPage)
            XCTAssertTrue(handler.list.count == 50)
            XCTAssertTrue(fetchingCount == 5)
            expectation.fulfill()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // Force retain
            cancellable.cancel()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    /// 測試 Reload 會將資料清回第一頁。
    func testReload() {
        // Arrange
        let handler = TestPagingHandler()
        let expectation = XCTestExpectation(description: "Test")

        // Act
        handler.fetchNext()
        handler.fetchNext()
        handler.fetchNext()
        handler.fetchNext()
        handler.fetchNext()
        handler.fetchNext()
        handler.reload()

        // Assert
        handler.pagingQueue.async {
            XCTAssertTrue(handler.hasNextPage)
            XCTAssertTrue(handler.list.count == 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
