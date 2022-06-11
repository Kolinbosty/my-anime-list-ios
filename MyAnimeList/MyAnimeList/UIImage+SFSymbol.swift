//
//  UIImage+SFSymbol.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit

extension UIImage {

    static var sf_circle: UIImage? {
        return sfImage(name: "circle", size: 24.0)
    }

    static var sf_circle_check: UIImage? {
        return sfImage(name: "checkmark.circle", size: 24.0)
    }

    private static func sfImage(name: String, size: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: size))
        return UIImage(systemName: name, withConfiguration: config)
    }
}
