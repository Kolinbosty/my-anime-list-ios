//
//  MangaPagingHandler.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import Foundation
import Combine
import Alamofire

class MangaPagingHandler: PagingHandler<MangaCellViewModel> {
    enum MangaType: String, CaseIterable {
        case manga
        case novel
        case lightnovel
        case oneshot
        case doujin
        case manhwa
        case manhua
    }

    enum MangaFilter: String, CaseIterable {
        case publishing
        case upcoming
        case bypopularity
        case favorite
    }

    @Published var queryTypes: Set<MangaType> = .init()
    @Published var queryFilters: Set<MangaFilter> = .init()

    private var cancellables: Set<AnyCancellable> = .init()

    override init() {
        super.init()
        setupBinding()

        // Setup provider
        itemsProvider = { [weak self] lastItem in
            return AF.fetchMangaPublisher(
                with: lastItem,
                types: self?.queryTypes.convertToQueryString,
                filters: self?.queryFilters.convertToQueryString
            )
        }
    }

    private func setupBinding() {
        // Reload while query values changed
        $queryTypes.removeDuplicates().combineLatest($queryFilters.removeDuplicates())
            .debounce(for: .milliseconds(50), scheduler: pagingQueue)
            .sink { [weak self] _ in
                self?.reload()
            }
            .store(in: &cancellables)
    }
}

// MARK: - API
fileprivate extension Alamofire.Session {
    func fetchMangaPublisher(with lastItem: MangaCellViewModel?, types: String?, filters: String?) -> AnyPublisher<(list: [MangaCellViewModel], hasNextPage: Bool), Error> {
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
        var urlComponents = URLComponents(string: "https://api.jikan.moe/v4/top/manga")!
        urlComponents.queryItems = params.map {
            return URLQueryItem(name: $0, value: $1)
        }

        // API
        return AF.request(urlComponents.url!)
            .publishDecodable(type: MangaListResult.self)
            .tryMap { resp throws -> (list: [MangaCellViewModel], hasNextPage: Bool) in
                switch resp.result {
                case .failure(let error):
                    throw error

                case .success(let result):
                    let cellVMs = result.data.map { MangaCellViewModel(data: $0, page: page) }
                    return (cellVMs, result.pagination.has_next_page)
                }
            }
            .eraseToAnyPublisher()
    }
}
