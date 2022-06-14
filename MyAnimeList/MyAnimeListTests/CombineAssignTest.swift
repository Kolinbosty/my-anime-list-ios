//
//  CombineAssignTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
import Combine
@testable import MyAnimeList

class TextCombineClass {
    let signal: PassthroughSubject<Int, Never> = .init()
    var value: Int = 0

    var cancellables: Set<AnyCancellable> = .init()

    init() {
        setupBinding()
    }

    func setupBinding() {
        signal
            .assign(to: \.value, on: self)
            .store(in: &cancellables)
    }
}

class CombineAssignTest: XCTestCase {

    // Note: 測試 Combine+Assign，如果會 leak 表示 assign self 會 retain。
    func testCombineAssignRelease() {
        // Arrange
        var obj: TextCombineClass? = .init()
        weak var observer = obj

        // Act
        obj?.signal.send(1)
        obj = nil

        // Assert
        XCTAssertNil(observer)
    }
}
