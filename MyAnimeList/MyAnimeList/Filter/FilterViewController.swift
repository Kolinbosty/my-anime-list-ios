//
//  FilterViewController.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit

class FilterViewController: UIViewController {
    typealias Completion = ([(name: String, selected: [FilterCellViewModel])]) -> Void

    private weak var tableView: UITableView!

    private let viewModel: FilterViewModel

    private var completion: Completion

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: FilterViewModel, completion: @escaping Completion) {
        self.viewModel = viewModel
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        setupUI()
        setupTableView()
        setupNavi()
    }

    private func setupNavi() {
        // Cancel
        let cancelBtn = UIButton(type: .system)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        let cancelItem = UIBarButtonItem(customView: cancelBtn)
        navigationItem.leftBarButtonItems = [cancelItem]

        // Apply
        let applyBtn = UIButton(type: .system)
        applyBtn.setTitle("Apply", for: .normal)
        applyBtn.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
        let applyItem = UIBarButtonItem(customView: applyBtn)
        navigationItem.rightBarButtonItems = [applyItem]
    }
}

// MARK: - Action
private extension FilterViewController {
    @objc func handleCancel() {
        dismiss(animated: true)
    }

    @objc func handleApply() {
        dismiss(animated: true) { [self] in
            // Callback
            let result = viewModel.selectionsData.map {
                return ($0.name, $0.selections.filter(\.isSelected))
            }
            completion(result)
        }
    }
}

// MARK: - TableView
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        // Register
        tableView.register(FilterCell.self, forCellReuseIdentifier: "Cell")

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.selectionsData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectionsData[section].selections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cellVM = viewModel.selectionsData[indexPath.section].selections[indexPath.item]

        // Binding
        if let filterCell = cell as? FilterCell {
            filterCell.binding(with: cellVM)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = viewModel.selectionsData[indexPath.section].selections[indexPath.item]

        cellVM.isSelected.toggle()
    }
}

// MARK: - Create UI
extension FilterViewController {
    private func setupUI() {
        view.backgroundColor = .white

        // Create
        createTableView()

        // Layout
        setupConstraint()
    }

    private func createTableView() {
        guard tableView == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Add
        view.addSubview(tableView)
        self.tableView = tableView
    }

    private func setupConstraint() {
        // Do nothing
    }
}
