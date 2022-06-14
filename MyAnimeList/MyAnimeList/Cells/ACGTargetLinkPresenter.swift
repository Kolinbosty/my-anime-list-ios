//
//  ACGTargetLinkPresenter.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/14.
//

import UIKit
import SafariServices

protocol ACGTargetLinkPresenter {
    func presentWebView(with cellVM: ACGListCellBindable)
}

extension ACGTargetLinkPresenter where Self: UIViewController {
    func presentWebView(with cellVM: ACGListCellBindable) {
        guard let link = cellVM.targerLink else {
            return
        }

        // Create
        let nextVC = SFSafariViewController(url: link)

        // Present
        present(nextVC, animated: true)
    }
}
