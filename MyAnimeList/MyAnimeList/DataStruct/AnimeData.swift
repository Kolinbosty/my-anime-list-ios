//
//  AnimeData.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

struct AnimeAiredData: Codable, ACGPeriodDisplay {
    let from: String
    let to: String?
}

struct AnimeData: Codable {
    let mal_id: Int
    let url: String
    let images: ACGImageData
    let title: String
    let rank: Int
    let aired: AnimeAiredData
}

extension AnimeData: Equatable {
    static func == (lhs: AnimeData, rhs: AnimeData) -> Bool {
        return lhs.mal_id == rhs.mal_id
    }
}
