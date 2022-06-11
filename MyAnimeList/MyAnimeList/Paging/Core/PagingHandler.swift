//
//  PagingHandler.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation
import Combine

enum PagingHandlerState {
    case idle
    case fetching
    case reloading
    case failure(error: Error)

    var canFetch: Bool {
        switch self {
        case .idle:
            return true
        default:
            return false
        }
    }

    var canReload: Bool {
        // Note: Reload can cancel fetching
        switch self {
        case .reloading:
            return false
        default:
            return true
        }
    }
}

class PagingHandler<ItemType: PagingUnit> {
    typealias PageDataResult = (list: [ItemType], hasNextPage: Bool)
    typealias ItemProvider = (ItemType?) -> AnyPublisher<PageDataResult, Error>

    @Published private(set) var state: PagingHandlerState = .idle
    @Published private(set) var list: [ItemType] = []
    @Published private(set) var hasNextPage: Bool = true
    private(set) var pagingQueue: DispatchQueue = .main
    private var pagingCancellable: AnyCancellable? = nil

    var itemsProvider: ItemProvider?

    func fetchNext() {
        guard let itemsProvider = itemsProvider else { return }

        pagingQueue.async { [self] in
            guard hasNextPage, state.canFetch else { return }

            // Start fetching
            state = .fetching

            // Fetching next
            pagingCancellable = itemsProvider(list.last)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        // End fetching
                        self?.state = .idle

                    case .failure(let error):
                        // Fail
                        self?.state = .failure(error: error)
                        self?.state = .idle
                    }
                } receiveValue: { [weak self] result in
                    // Modify data
                    self?.list.append(contentsOf: result.list)
                    self?.hasNextPage = result.hasNextPage
                }
        }
    }

    func reload() {
        guard let itemsProvider = itemsProvider else { return }

        pagingQueue.async { [self] in
            // Start reload
            state = .reloading

            // Always get first page
            pagingCancellable = itemsProvider(nil)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        // End fetching
                        self?.state = .idle

                    case .failure(let error):
                        // Fail
                        self?.state = .failure(error: error)
                        self?.state = .idle
                    }
                } receiveValue: { [weak self] result in
                    // Modify data
                    self?.list = result.list
                    self?.hasNextPage = result.hasNextPage
                }
        }
    }
}

// Note: 每次都要寫 Properties，太麻煩？
//protocol PagingHandler: AnyObject {
//    associatedtype ItemType: PagingUnit
//
//    var state: CurrentValueSubject<PagingHandlerState, Never> { get }
//    var list: [ItemType] { get set }
//    var hasNextPage: Bool { get set }
//    var isLoading: Bool { get set }
//    var pagingQueue: DispatchQueue { get }
//    var pagingCancellable: AnyCancellable? { get set }
//
//    /// Need implemented
//    func itemsProvider(lastItem: ItemType?) -> AnyPublisher<([ItemType], Bool), Error>
//
//    /// Default implemented
//    func fetchNext()
//    func reload()
//}
//
//extension PagingHandler {
//    func fetchNext() {
//        guard hasNextPage else { return }
//
//        pagingQueue.async { [self] in
//            guard state.value.canFetch else { return }
//
//            // Start fetching
//            state.send(.fetching)
//
//            // Fetching next
//            pagingCancellable = itemsProvider(lastItem: list.last)
//                .sink { [weak self] completion in
//                    switch completion {
//                    case .finished:
//                        // End fetching
//                        self?.state.send(.idle)
//
//                    case .failure(let error):
//                        // Fail
//                        self?.state.send(.failure(error: error))
//                        self?.state.send(.idle)
//                    }
//                } receiveValue: { [weak self] (result, hasNextPage) in
//                    self?.list.append(contentsOf: result)
//                    self?.hasNextPage = hasNextPage
//                }
//        }
//    }
//
//    func reload() {
//        pagingQueue.async { [self] in
//            // Start reload
//            state.send(.reloading)
//
//            // Always get first page
//            pagingCancellable = itemsProvider(lastItem: nil)
//                .sink { [weak self] completion in
//                    switch completion {
//                    case .finished:
//                        // End fetching
//                        self?.state.send(.idle)
//
//                    case .failure(let error):
//                        // Fail
//                        self?.state.send(.failure(error: error))
//                        self?.state.send(.idle)
//                    }
//                } receiveValue: { [weak self] (result, hasNextPage) in
//                    self?.list = result
//                    self?.hasNextPage = hasNextPage
//                }
//        }
//    }
//}
