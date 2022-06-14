//
//  FavoriteManager.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import Foundation
import Combine

struct FavoriteManager {

    private static let userDefaultKey = "Favorite"

    static private(set) var favoriteList: CurrentValueSubject<[FavoriteUnit], Never> = {
        // Default
        var favorites: [FavoriteUnit] = []

        // Load from local
        if let favoriteData = UserDefaults.standard.object(forKey: userDefaultKey) as? Data {
            let decoder = JSONDecoder()
            if let localFavorite = try? decoder.decode([FavoriteUnit].self, from: favoriteData) {
                favorites = localFavorite
            }
        }

        return CurrentValueSubject<[FavoriteUnit], Never>(favorites)
    }()

    static func add(_ unit: FavoriteUnit) {
        // Add
        var list = favoriteList.value
        list.append(unit)

        // Save
        favoriteList.send(list)
        saveToLocal()
    }

    static func remove(_ unit: FavoriteUnit) {
        // Remove
        var list = favoriteList.value
        if let index = list.firstIndex(where: { $0 == unit }) {
            list.remove(at: index)
        }

        // Save
        favoriteList.send(list)
        saveToLocal()
    }

    static private func saveToLocal() {
        // Save to UserDefaults
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoriteList.value) {
            UserDefaults.standard.set(encoded, forKey: userDefaultKey)
        }
    }

    static func isAnimeFavorite(_ anime: AnimeData) -> Bool {
        let unit = FavoriteUnit(anime: anime)
        return favoriteList.value.first(where: { $0 == unit }) != nil
    }

    static func isMangaFavorite(_ mange: MangaData) -> Bool {
        let unit = FavoriteUnit(manga: mange)
        return favoriteList.value.first(where: { $0 == unit }) != nil
    }

    static func clean() {
        favoriteList.send([])
        UserDefaults.standard.set(nil, forKey: userDefaultKey)
    }
}
