//
//  DummyData.swift
//  MyAnimeListTests
//
//  Created by Alex Lin 公司 on 2022/6/13.
//

import Foundation
@testable import MyAnimeList

extension ACGImageLinksData {
    static var dummy: ACGImageLinksData {
        return .init(
            image_url: "http://google.com",
            small_image_url: "http://google.com",
            large_image_url: "http://google.com")
    }
}

extension ACGImageData {
    static var dummy: ACGImageData {
        .init(jpg: .dummy,
              webp: .dummy)
    }
}

extension AnimeAiredData {
    static var dummy: AnimeAiredData {
        return .init(from: "2009-03-17T00:00:00+00:00", to: nil)
    }
}

extension AnimeData {
    static var dummy: AnimeData {
        return .init(
            mal_id: 1,
            url: "http://google.com",
            images: .dummy,
            title: "anime",
            rank: 1,
            aired: .dummy
        )
    }
}

extension MangaPublishedData {
    static var dummy: MangaPublishedData {
        .init(from: "2009-03-17T00:00:00+00:00", to: nil)
    }
}

extension MangaData {
    static var dummy: MangaData {
        return .init(
            mal_id: 2,
            url: "http://google.com",
            images: .dummy,
            title: "manga",
            rank: 1,
            published: .dummy
        )
    }
}
