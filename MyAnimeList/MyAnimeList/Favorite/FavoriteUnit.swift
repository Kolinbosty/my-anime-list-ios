//
//  FavoriteUnit.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import Foundation

struct FavoriteUnit: Codable, Equatable {
    enum FavoriteType: Codable, Equatable {
        case anime(AnimeData)
        case manga(MangaData)
    }

    let type: FavoriteType

    init(anime: AnimeData) {
        self.type = .anime(anime)
    }

    init(manga: MangaData) {
        self.type = .manga(manga)
    }

    func isEqualTo(anime: AnimeData) -> Bool {
        switch type {
        case .anime(let unitAnimeData):
            return anime == unitAnimeData
        case .manga(_):
            return false
        }
    }

    func isEqualTo(manga: MangaData) -> Bool {
        switch type {
        case .anime(_):
            return false
        case .manga(let unitMangaData):
            return manga == unitMangaData
        }
    }
}

extension FavoriteUnit {
    var listCellViewModel: ACGListCellBindable {
        switch type {
        case .anime(let data):
            return AnimeCellViewModel(data: data)

        case .manga(let data):
            return MangaCellViewModel(data: data)
        }
    }
}
