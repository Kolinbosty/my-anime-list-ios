//
//  ACGImageData.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import Foundation

struct ACGImageLinksData: Codable {
    let image_url: String?
    let small_image_url: String?
    let large_image_url: String?
}

struct ACGImageData: Codable {
    let jpg: ACGImageLinksData
    let webp: ACGImageLinksData
}
