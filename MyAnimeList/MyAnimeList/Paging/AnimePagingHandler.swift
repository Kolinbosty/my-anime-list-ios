//
//  AnimePagingHandler.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation
import Combine
import Alamofire

class AnimePagingHandler: PagingHandler<AnimeCellViewModel> {
    enum AnimeType: String, CaseIterable {
        case tv
        case movie
        case ova
        case special
        case ona
        case music
    }

    enum AnimeFilter: String, CaseIterable {
        case airing
        case upcoming
        case bypopularity
        case favorite
    }

    var queryTypes: Set<AnimeType> = .init() {
        didSet {
            self.reload()
        }
    }

    var queryFilters: Set<AnimeFilter> = .init() {
        didSet {
            self.reload()
        }
    }

    override init() {
        super.init()

        // Setup provider
        itemsProvider = { [weak self] lastItem in
            return AF.fetchAnimationPublisher(
                with: lastItem,
                types: self?.queryTypesString,
                filters: self?.queryFiltersString
            )
        }
    }
}

// MARK: - Tools
private extension AnimePagingHandler {
    var queryTypesString: String? {
        guard queryTypes.isEmpty else {
            return nil
        }

        return queryTypes
            .map(\.rawValue)
            .joined(separator: ",")
    }

    var queryFiltersString: String? {
        guard queryFilters.isEmpty else {
            return nil
        }

        return queryFilters
            .map(\.rawValue)
            .joined(separator: ",")
    }
}

// MARK: - API
fileprivate extension Alamofire.Session {
    func fetchAnimationPublisher(with lastItem: AnimeCellViewModel?, types: String?, filters: String?) -> AnyPublisher<(list: [AnimeCellViewModel], hasNextPage: Bool), Error> {
        // Parameters
        var page = 1
        if let lastItem = lastItem {
            page = lastItem.page + 1
        }
        var params: [String: String] = [
            "page": "\(page)"
        ]
        if let types = types {
            params["type"] = types
        }
        if let filters = filters {
            params["filter"] = filters
        }

        // Request
        var urlComponents = URLComponents(string: "https://api.jikan.moe/v4/top/anime")!
        urlComponents.queryItems = params.map {
            return URLQueryItem(name: $0, value: $1)
        }

        // API
        return AF.request(urlComponents.url!)
            .publishDecodable(type: AnimeListResult.self)
            .tryMap { resp throws -> (list: [AnimeCellViewModel], hasNextPage: Bool) in
                switch resp.result {
                case .failure(let error):
                    throw error

                case .success(let result):
                    let cellVMs = result.data.map { AnimeCellViewModel(data: $0, page: page) }
                    return (cellVMs, result.pagination.has_next_page)
                }
            }
            .eraseToAnyPublisher()
    }
}
