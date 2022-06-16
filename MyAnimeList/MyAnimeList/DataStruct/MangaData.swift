//
//  MangaData.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

struct MangaPublishedData: Codable, ACGPeriodDisplay {
    let from: String
    let to: String?
}

struct MangaData: Codable {
    let mal_id: Int
    let url: String
    let images: ACGImageData
    let title: String
    let rank: Int
    let published: MangaPublishedData
}

extension MangaData: Equatable {
    static func == (lhs: MangaData, rhs: MangaData) -> Bool {
        return lhs.mal_id == rhs.mal_id
    }
}
