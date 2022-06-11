//
//  MangaCellViewModel.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

class MangaCellViewModel: NSObject {
    let data: MangaData

    init(data: MangaData) {
        self.data = data
        super.init()
    }
}
