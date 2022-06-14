//
//  FavoriteListViewController.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/14.
//

import UIKit
import Combine

class FavoriteListViewController: UIViewController {

    enum Section {
        case list
    }

    @IBOutlet weak var tableView: UITableView!

    private var cancellables: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        setupBinding()
    }

    private func setupBinding() {

    }
}

// MARK: - TableView
extension FavoriteListViewController {

}
