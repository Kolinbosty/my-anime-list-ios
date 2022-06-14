//
//  FilterViewModel.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

class FilterViewModel {
    typealias SectionRawData = (name: String, selections: [String])
    typealias SectionData = (name: String, selections: [FilterCellViewModel])

    let selectionsData: [SectionData]

    init(sections: [SectionRawData], defaultSelection: [String: [String]]) {
        self.selectionsData = sections.map { (name: String, selections: [String]) in
            // Create cell view models
            let cellVMs = selections.map { selectioName in
                return FilterCellViewModel(
                    name: selectioName,
                    isSelected: defaultSelection[name]?.contains(selectioName) ?? false
                )
            }

            return (name, cellVMs)
        }
    }
}
