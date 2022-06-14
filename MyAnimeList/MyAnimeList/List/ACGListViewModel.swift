//
//  ACGListViewModel.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import UIKit
import Combine

class ACGListViewModel {

    enum ListType: Int, CaseIterable {
        case anime = 0
        case manga = 1

        var displayName: String {
            switch self {
            case .anime:
                return "ANIME"
            case .manga:
                return "MANGA"
            }
        }
    }

    private let animePagingHandler: AnimePagingHandler = .init()
    private let mangaPagingHandler: MangaPagingHandler = .init()

    @Published var listType: ListType = .anime
    @Published private(set) var currentListVMs: [ACGListCellBindable] = []
    @Published private(set) var currentState: PagingHandlerState = .idle

    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        setupBinding()
    }

    private func setupBinding() {
        // List
        let animeListPublisher = animePagingHandler.$list
            .map { list -> [ACGListCellBindable] in list }
        let mangeListPubliser = mangaPagingHandler.$list
            .map { list -> [ACGListCellBindable] in list }

        $listType.combineLatest(animeListPublisher, mangeListPubliser)
            .map { type, animeList, mangaList -> [ACGListCellBindable] in
                switch type {
                case .anime:
                    return animeList
                case .manga:
                    return mangaList
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentListVMs, on: self)
            .store(in: &cancellables)

        // State
        let animeState = animePagingHandler.$state
        let mangaState = mangaPagingHandler.$state

        $listType.combineLatest(animeState, mangaState)
            .map { type, animeState, mangaState in
                switch type {
                case .anime:
                    return animeState
                case .manga:
                    return mangaState
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentState, on: self)
            .store(in: &cancellables)
    }
}

extension ACGListViewModel {
    func createFilterVC() -> UIViewController {
        switch listType {
        case .anime:
            // ANIME
            let currentType = Array(animePagingHandler.queryTypes)
            let currentFilter = Array(animePagingHandler.queryFilters)
            let nextVC = FilterViewController.createFilter(selectedA: currentType, selectedB: currentFilter) { [weak self] selectedType, selectedFilter in
                self?.animePagingHandler.queryTypes = Set(selectedType)
                self?.animePagingHandler.queryFilters = Set(selectedFilter)
            }
            return nextVC

        case .manga:
            // MANGA
            let currentType = Array(mangaPagingHandler.queryTypes)
            let currentFilter = Array(mangaPagingHandler.queryFilters)
            let nextVC = FilterViewController.createFilter(selectedA: currentType, selectedB: currentFilter) { [weak self] selectedType, selectedFilter in
                self?.mangaPagingHandler.queryTypes = Set(selectedType)
                self?.mangaPagingHandler.queryFilters = Set(selectedFilter)
            }
            return nextVC
        }
    }

    func handlePullToRefresh() {
        switch listType {
        case .anime:
            animePagingHandler.reload()
        case .manga:
            mangaPagingHandler.reload()
        }
    }

    func needFetchNextPage() {
        switch listType {
        case .anime:
            animePagingHandler.fetchNext()
        case .manga:
            mangaPagingHandler.fetchNext()
        }
    }
}
