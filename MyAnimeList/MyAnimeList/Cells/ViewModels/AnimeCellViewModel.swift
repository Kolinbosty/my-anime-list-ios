//
//  AnimeCellViewModel.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit
import Combine

class AnimeCellViewModel: NSObject {
    let data: AnimeData
    let page: Int

    @Published private var isFavorite = false

    private var cancellables: Set<AnyCancellable> = .init()

    init(data: AnimeData, page: Int) {
        self.data = data
        self.page = page
        super.init()

        setupBinding()
    }

    private func setupBinding() {
        // Check favorite
        let animeData = data
        FavoriteManager.favoriteList
            .map { newList in
                return newList.first(where: { $0.isEqualTo(anime: animeData) }) != nil
            }
            .assign(to: \.isFavorite, on: self)
            .store(in: &cancellables)
    }
}

extension AnimeCellViewModel: PagingUnit {
    var pagingIdentifier: AnyHashable {
        return page
    }
}

extension AnimeCellViewModel: ACGListCellBindable {
    var listPhotoURL: AnyPublisher<URL?, Never> {
        let imageURL = data.images.jpg.image_url.flatMap(URL.init)
        return Just(imageURL)
            .eraseToAnyPublisher()
    }

    var listRankText: AnyPublisher<String?, Never> {
        return Just<String?>("Rank: \(data.rank)")
            .eraseToAnyPublisher()
    }

    var listTitle: AnyPublisher<String?, Never> {
        return Just<String?>("Title: \(data.title)")
            .eraseToAnyPublisher()
    }

    var listPeriodText: AnyPublisher<String?, Never> {
        return Just<String?>(data.aired.toPeriodText)
            .eraseToAnyPublisher()
    }

    var listHeartIcon: AnyPublisher<UIImage?, Never> {
        return $isFavorite
            .map { isFavorit -> UIImage? in
                return isFavorit ? .sf_heart_fill : .sf_heart
            }
            .eraseToAnyPublisher()
    }

    var targerLink: URL? {
        let encodedURLStr = data.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedURLStr.flatMap(URL.init)
    }

    func handleHeartTapped() {
        // Modify favorite
        let unit = FavoriteUnit(anime: data)
        if isFavorite {
            FavoriteManager.remove(unit)
        } else {
            FavoriteManager.add(unit)
        }
    }
}

