//
//  SearchArticleModels.swift
//  NYT
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation

struct SearchArticlesModel : Codable {
    let status: String
    let response: Response
}

struct Response: Codable {
    let docs: [Docs]
}

struct Docs: Codable {
    let pubDate: String
    let headline: Headline
}

struct Headline: Codable {
    let main: String
}
