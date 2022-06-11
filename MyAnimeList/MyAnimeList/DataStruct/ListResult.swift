//
//  ListResult.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

struct PaginationData: Codable {
    let has_next_page: Bool
}

struct ListResult<DataType: Codable>: Codable {
    let data: [DataType]
    let pagination: PaginationData
}

typealias AnimeListResult = ListResult<AnimeData>
typealias MangaListResult = ListResult<MangaData>
