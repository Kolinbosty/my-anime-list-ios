//
//  FavoriteListViewController.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/14.
//

import UIKit
import Combine

extension FavoriteUnit: Hashable {
    func hash(into hasher: inout Hasher) {
        switch type {
        case .anime(let data):
            hasher.combine("anime")
            hasher.combine(data.mal_id)
            hasher.combine(data.title)
        case .manga(let data):
            hasher.combine("manga")
            hasher.combine(data.mal_id)
            hasher.combine(data.title)
        }
    }
}

class FavoriteListViewModel {
    typealias Section = FavoriteListViewController.Section
    typealias DataSource = UITableViewDiffableDataSource<Section, FavoriteUnit>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FavoriteUnit>

    @Published var dataSource: DataSource?

    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        setupBinding()
    }

    private func setupBinding() {
        // Apply Snapshot
        FavoriteManager.favoriteList.combineLatest($dataSource)
            .sink { [weak self] favs, dataSource in
                guard let self = self, let dataSource = dataSource else {
                    return
                }

                let snapshot = self.createSnapshot(from: favs)
                dataSource.apply(snapshot)
            }
            .store(in: &cancellables)
    }

    func createSnapshot(from favs: [FavoriteUnit]) -> Snapshot {
        // Create
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(
            favs,
            toSection: .list
        )

        return snapshot
    }
}

class FavoriteListViewController: UIViewController, ACGTargetLinkPresenter {

    enum Section {
        case list
    }

    @IBOutlet weak var tableView: UITableView!

    private var viewModel: FavoriteListViewModel = .init()

    private var cancellables: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        setupTableView()
    }
}

// MARK: - TableView
extension FavoriteListViewController: UITableViewDelegate {
    func setupTableView() {
        // Register
        tableView.register(ACGListCell.self, forCellReuseIdentifier: "Cell")

        // Config DataSource
        viewModel.dataSource = .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            // Binding
            if let listCell = cell as? ACGListCell {
                listCell.binding(with: itemIdentifier.listCellViewModel)
            }

            return cell
        }
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = viewModel.dataSource else { return }

        // Present
        let fav = dataSource.snapshot().itemIdentifiers(inSection: .list)[indexPath.item]
        presentWebView(with: fav.listCellViewModel)
    }
}
