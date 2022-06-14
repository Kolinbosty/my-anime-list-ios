//
//  ACGPeriodDisplayTest.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import XCTest
@testable import MyAnimeList

struct TestPeriodStruct: ACGPeriodDisplay {
    var from: String = ""
    var to: String? = nil
}

class ACGPeriodDisplayTest: XCTestCase {

    func testACGPeriodDisplayParsing() {
        // Arrange
        var period = TestPeriodStruct()

        // Action
        period.from = "2009-03-17T00:00:00+00:00"
        period.to = "2021-03-17T00:00:00+00:00"

        // Assert
        XCTAssertNotNil(period.fromDate)
        XCTAssertNotNil(period.toDate)
        XCTAssertEqual(period.toPeriodText, "2009-03-17 ~ 2021-03-17")
    }

    func testACGPeriodDisplayParsingFail() {
        // Arrange
        var period = TestPeriodStruct()
        period.from = "this is invalid format"

        // Assert
        XCTAssertNil(period.fromDate)
        XCTAssertNil(period.toDate)
        XCTAssertEqual(period.toPeriodText, " ~ ")
    }
}
