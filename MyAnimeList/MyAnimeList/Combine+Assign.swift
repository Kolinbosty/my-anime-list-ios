//
//  Combine+Assign.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation
import Combine

// Note: 解決 assing self 會有 leak 的風險的問題。
extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
