//
//  ArticlesModel.swift
//  NYT
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation

struct PopularArticlesModel: Codable {
    let status: String
    let results: [PopularArticleModel]
}

struct PopularArticleModel: Codable {
    let title: String
    let publishedDate: String
}
