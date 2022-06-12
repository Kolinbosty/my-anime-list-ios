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

    init(data: MangaData, page: Int) {
        self.data = data
        self.page = page
        super.init()
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
        // TODO: NOT FIN
        return Just<Bool>(false)
            .map { isFavorit -> UIImage? in
                return isFavorit ? .sf_heart_fill : .sf_heart
            }
            .eraseToAnyPublisher()
    }

    func handleHeartTapped() {
        // TODO: NOT FIN
    }
}
