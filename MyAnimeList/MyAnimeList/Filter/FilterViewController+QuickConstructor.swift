//
//  FilterViewController+QuickConstructor.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit

// MARK: - Quick Constructor
extension FilterViewController {
    static func createAnimeFilter(selectdType: [AnimePagingHandler.AnimeType], selectdFilter: [AnimePagingHandler.AnimeFilter], completion: @escaping ([AnimePagingHandler.AnimeType], [AnimePagingHandler.AnimeFilter]) -> Void) -> UIViewController {

        let typeKeyName = "Type"
        let filterKeyName = "Filter"

        // Create all selection raw data
        let allSelection: [FilterViewModel.SectionRawData] = [
            (typeKeyName, AnimePagingHandler.AnimeType.allCases.map { $0.rawValue }),
            (filterKeyName, AnimePagingHandler.AnimeFilter.allCases.map { $0.rawValue }),
        ]

        // Create default selection data
        let defualtSelection = [
            typeKeyName: selectdType.map { $0.rawValue },
            filterKeyName: selectdFilter.map { $0.rawValue },
        ]

        // Create VC
        let viewModel: FilterViewModel = .init(sections: allSelection, defaultSelection: defualtSelection)
        let vc = FilterViewController(viewModel: viewModel) { result in
            // Mapping completion
            var newSelectedType: [AnimePagingHandler.AnimeType] = []
            var newSelectedFilter: [AnimePagingHandler.AnimeFilter] = []

            result.forEach { (name: String, selected: [FilterCellViewModel]) in
                switch name {
                case typeKeyName:
                    newSelectedType = selected.compactMap {
                        AnimePagingHandler.AnimeType(rawValue: $0.name)
                    }

                case filterKeyName:
                    newSelectedFilter = selected.compactMap {
                        AnimePagingHandler.AnimeFilter(rawValue: $0.name)
                    }

                default:
                    assert(false, "This will not happend. something wrong...")
                }
            }

            // Completion
            completion(newSelectedType, newSelectedFilter)
        }
        let naviVC = UINavigationController(rootViewController: vc)

        return naviVC
    }
}
