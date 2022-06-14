//
//  SFSymbolImageTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
@testable import MyAnimeList

class SFSymbolImageTest: XCTestCase {

    func testAllResourceNotNil() {
        // Arrange
        // Do nothing

        // Act
        // Do nothing

        // Assert
        XCTAssertNotNil(UIImage.sf_heart)
        XCTAssertNotNil(UIImage.sf_circle)
        XCTAssertNotNil(UIImage.sf_heart_fill)
        XCTAssertNotNil(UIImage.sf_circle_check)
    }
}
