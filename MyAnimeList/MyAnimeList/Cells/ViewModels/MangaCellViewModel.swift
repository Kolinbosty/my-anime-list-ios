//
//  MangaCellViewModel.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit
import Combine

class MangaCellViewModel: NSObject {
    let data: MangaData
    let page: Int

    @Published private var isFavorite = false

    private var cancellables: Set<AnyCancellable> = .init()

    init(data: MangaData, page: Int) {
        self.data = data
        self.page = page
        super.init()

        setupBinding()
    }

    private func setupBinding() {
        // Check favorite
        let mangaData = data
        FavoriteManager.favoriteList
            .map { newList in
                return newList.first(where: { $0.isEqualTo(manga: mangaData) }) != nil
            }
            .assign(to: \.isFavorite, on: self)
            .store(in: &cancellables)
    }
}

extension MangaCellViewModel: PagingUnit {
    var pagingIdentifier: AnyHashable {
        return page
    }
}

extension MangaCellViewModel: ACGListCellBindable {
    var listPhotoURL: AnyPublisher<URL?, Never> {
        let imageURL = data.images.jpg.image_url.flatMap(URL.init)
        return Just(imageURL)
            .eraseToAnyPublisher()
    }

    var listRankText: AnyPublisher<String?, Never> {
        return Just<String?>("\(data.rank)")
            .eraseToAnyPublisher()
    }

    var listTitle: AnyPublisher<String?, Never> {
        return Just<String?>(data.title)
            .eraseToAnyPublisher()
    }

    var listPeriodText: AnyPublisher<String?, Never> {
        return Just<String?>(data.published.toPeriodText)
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
        let unit = FavoriteUnit(manga: data)
        if isFavorite {
            FavoriteManager.remove(unit)
        } else {
            FavoriteManager.add(unit)
        }
    }
}
