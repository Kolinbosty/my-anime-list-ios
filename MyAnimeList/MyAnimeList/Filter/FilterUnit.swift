//
//  FilterUnit.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import Foundation

// TODO: 可以測這個？
protocol FilterUnit: RawRepresentable, CaseIterable where RawValue == String {
    init?(filterCellVM: FilterCellViewModel)

    static var allCasesString: [String] { get }

    static var filterSectionName: String { get }

    static var allCasesFilterData: (String, [String]) { get }
}

extension FilterUnit  {
    init?(filterCellVM: FilterCellViewModel) {
        self.init(rawValue: filterCellVM.name)
    }

    static var allCasesFilterData: (String, [String]) {
        return (filterSectionName, allCasesString)
    }

    static var allCasesString: [String] {
        return allCases.map { $0.rawValue }
    }
}

extension AnimePagingHandler.AnimeType: FilterUnit {
    static var filterSectionName: String {
        return "Type"
    }
}

extension AnimePagingHandler.AnimeFilter: FilterUnit {
    static var filterSectionName: String {
        return "Filter"
    }
}

extension MangaPagingHandler.MangaType: FilterUnit {
    static var filterSectionName: String {
        return "Type"
    }
}

extension MangaPagingHandler.MangaFilter: FilterUnit {
    static var filterSectionName: String {
        return "Filter"
    }
}

extension Set where Element: FilterUnit {
    var convertToQueryString: String? {
        guard !isEmpty else { return nil }
        return map(\.rawValue).joined(separator: ",")
    }
}
