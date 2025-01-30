//
//  Article.swift
//  NewsApp
//
//  Created by Jaya on 27/01/25.
//

import Foundation
struct Article: Codable {
    let title: String
    let description: String?
    let author: String?
    let url: String
    let urlToImage: String?
}
