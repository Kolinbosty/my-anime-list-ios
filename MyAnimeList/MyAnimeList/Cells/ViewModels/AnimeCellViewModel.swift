//
//  AnimeCellViewModel.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

class AnimeCellViewModel: NSObject {
    let data: AnimeData
    let page: Int

    init(data: AnimeData, page: Int) {
        self.data = data
        self.page = page
        super.init()
    }
}

extension AnimeCellViewModel: PagingUnit {
    var pagingIdentifier: AnyHashable {
        return page
    }
}
