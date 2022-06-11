//
//  FilterCellViewModel.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit
import Combine

class FilterCellViewModel {
    @Published var name: String
    @Published var isSelected: Bool

    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }

    var iconPublisher: AnyPublisher<UIImage?, Never> {
        return $isSelected
            .map { isSelected -> UIImage? in
                return isSelected ? .sf_circle_check : .sf_circle
            }
            .eraseToAnyPublisher()
    }
}
