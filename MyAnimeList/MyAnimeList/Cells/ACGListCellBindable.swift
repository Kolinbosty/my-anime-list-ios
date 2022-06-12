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

    func handleHeartTapped()

    func convertToAnyBindable() -> AnyACGListCellBindable
}

extension ACGListCellBindable {
    func convertToAnyBindable() -> AnyACGListCellBindable {
        return .init(self)
    }
}

class AnyACGListCellBindable: NSObject, ACGListCellBindable {

    let base: ACGListCellBindable

    init<B>(_ base: B) where B : ACGListCellBindable {
        self.base = base
    }

    var listPhotoURL: AnyPublisher<URL?, Never> { base.listPhotoURL }
    var listRankText: AnyPublisher<String?, Never> { base.listRankText }
    var listTitle: AnyPublisher<String?, Never> { base.listTitle }
    var listPeriodText: AnyPublisher<String?, Never> { base .listPeriodText }
    var listHeartIcon: AnyPublisher<UIImage?, Never> { base.listHeartIcon }

    func handleHeartTapped() {
        base.handleHeartTapped()
    }
}
