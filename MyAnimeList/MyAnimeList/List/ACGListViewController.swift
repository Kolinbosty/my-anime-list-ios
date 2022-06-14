//
//  ACGListViewController.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import UIKit
import Combine

class ACGListViewController: UIViewController, ACGTargetLinkPresenter {

    enum Section {
        case list
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private weak var refreshControl: UIRefreshControl!

    private var viewModel: ACGListViewModel = .init()
    private var currentListVMs: [ACGListCellBindable] = []

    private var cancellables: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        setupUI()
        setupTableView()
        setupBinding()
    }

    private func setupBinding() {
        // Reload tableView
        viewModel.$currentListVMs
            .sink { [weak self] newListVMs in
                self?.currentListVMs = newListVMs
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK - Actions
private extension ACGListViewController {
    @IBAction func handleFilterBtnTapped(_ sender: Any) {
        let nextVC = viewModel.createFilterVC()
        present(nextVC, animated: true)
    }

    @IBAction func handleSegmentedControlChanged(_ sender: Any) {
        guard let listType = ACGListViewModel.ListType(rawValue: segmentedControl.selectedSegmentIndex) else {
            return
        }

        // Update
        viewModel.listType = listType
    }

    @objc func handleRefreshEvent() {
        viewModel.handlePullToRefresh()
    }
}

// MARK: - TableView
extension ACGListViewController: UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        // Register
        tableView.register(ACGListCell.self, forCellReuseIdentifier: "Cell")

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentListVMs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cellVM = currentListVMs[indexPath.item]

        // Binding
        if let listCell = cell as? ACGListCell {
            listCell.binding(with: cellVM)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellVMs = currentListVMs
        let reachLast = indexPath.item == cellVMs.count - 1
        if reachLast {
            viewModel.needFetchNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = currentListVMs[indexPath.item]
        presentWebView(with: cellVM)
    }
}

// MARK: - Config UI
private extension ACGListViewController {
    func setupUI() {
        setupSegmentedControl()
        setupRefreshControl()
    }

    func setupSegmentedControl() {
        // Get all list type
        let listTypes = ACGListViewModel.ListType.allCases
        listTypes.enumerated().forEach { [self] (index, type) in
            segmentedControl.setTitle(type.displayName, forSegmentAt: index)
        }

        // Binding
        viewModel.$listType
            .subscribe(on: DispatchQueue.main)
            .map(\.rawValue)
            .assign(to: \.selectedSegmentIndex, on: segmentedControl)
            .store(in: &cancellables)
    }

    func setupRefreshControl() {
        // Create
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshEvent), for: .valueChanged)

        // Add
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl

        // Binding
        viewModel.$currentState
            .sink { state in
                switch state {
                case .reloading:
                    refreshControl.beginRefreshing()
                default:
                    refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
}
