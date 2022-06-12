//
//  FilterViewController+QuickConstructor.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit

// MARK: Quick Constructor
extension FilterViewController {
    static func createFilter<A: FilterUnit, B: FilterUnit>(selectedA: [A], selectedB: [B], completion: @escaping ([A], [B]) -> Void) -> UIViewController {
        // Create all selection raw data
        let allSelection: [FilterViewModel.SectionRawData] = [
            A.allCasesFilterData,
            B.allCasesFilterData,
        ]

        // Create default selection data
        let defualtSelection = [
            A.filterSectionName: selectedA.map { $0.rawValue },
            B.filterSectionName: selectedB.map { $0.rawValue },
        ]

        // Create VC
        let viewModel: FilterViewModel = .init(sections: allSelection, defaultSelection: defualtSelection)
        let vc = FilterViewController(viewModel: viewModel) { result in
            // Mapping completion
            var newSelectedA: [A] = []
            var newSelectedB: [B] = []

            result.forEach { (name: String, selected: [FilterCellViewModel]) in
                switch name {
                case A.filterSectionName:
                    newSelectedA = selected.compactMap(A.init)

                case B.filterSectionName:
                    newSelectedB = selected.compactMap(B.init)

                default:
                    assert(false, "This will not happend. something wrong...")
                }
            }

            // Completion
            completion(newSelectedA, newSelectedB)
        }
        let naviVC = UINavigationController(rootViewController: vc)

        return naviVC
    }
}
