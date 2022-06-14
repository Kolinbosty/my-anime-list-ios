//
//  PagingUnit.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

// Note: Remove AnyPagingUnit?

protocol PagingUnit {
    var pagingIdentifier: AnyHashable { get }

    func toAnyPagingUnit() -> AnyPagingUnit
}

extension PagingUnit {
    func toAnyPagingUnit() -> AnyPagingUnit {
        return .init(self)
    }
}

struct AnyPagingUnit {
    private let base: PagingUnit

    init<U>(_ base: U) where U : PagingUnit {
        self.base = base
    }
}
