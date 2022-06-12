//
//  ACGPeriodDisplay.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import Foundation

protocol ACGPeriodDisplay {
    var from: String { get }
    var to: String? { get }

    var toPeriodText: String { get }
}

extension ACGPeriodDisplay {
    // TODO: TEST THIS
    var toPeriodText: String {
        // Parsing formatter
        // 2009-03-17T00:00:00+00:00
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        // Display formatter
        let displayFormat = "yyyy-MM-dd"
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = displayFormat
        displayFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let fromText = dateFormatter.date(from: from).flatMap {
            displayFormatter.string(from: $0)
        }
        let toText = to.flatMap {
            dateFormatter.date(from: $0)
        }.flatMap {
            displayFormatter.string(from: $0)
        }

        return "\(fromText ?? "") ~ \(toText ?? "")"
    }
}
