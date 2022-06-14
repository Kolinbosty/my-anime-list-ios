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

    private var parseFormatter: DateFormatter {
        // 2009-03-17T00:00:00+00:00
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        return dateFormatter
    }

    private var displayFormatter: DateFormatter {
        let displayFormat = "yyyy-MM-dd"
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = displayFormat
        displayFormatter.timeZone = TimeZone(abbreviation: "UTC")

        return displayFormatter
    }

    var fromDate: Date? {
        return parseFormatter.date(from: from)
    }

    var toDate: Date? {
        let formatter = parseFormatter
        return to.flatMap {
            formatter.date(from: $0)
        }
    }

    var toPeriodText: String {
        let fromText = fromDate.flatMap {
            displayFormatter.string(from: $0)
        }
        let toText = toDate.flatMap {
            displayFormatter.string(from: $0)
        }

        return "\(fromText ?? "") ~ \(toText ?? "")"
    }
}
