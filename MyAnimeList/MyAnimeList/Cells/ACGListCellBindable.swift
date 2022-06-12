//
//  ACGListCellBindable.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import UIKit
import Combine

protocol ACGListCellBindable {
    var listPhotoURL: AnyPublisher<URL?, Never> { get }
    var listRankText: AnyPublisher<String?, Never> { get }
    var listTitle: AnyPublisher<String?, Never> { get }
    var listPeriodText: AnyPublisher<String?, Never> { get }
    var listHeartIcon: AnyPublisher<UIImage?, Never> { get }

    var targerLink: URL? { get }

    func handleHeartTapped()
}
