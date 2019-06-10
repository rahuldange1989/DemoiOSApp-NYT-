//
//  AppConstants.swift
//  NYT
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation

let SERVER_URL = "https://api.nytimes.com/svc/"
let API_KEY_NYT = "CE5kmw1Fit6AUmcvMDITnOBvXLCIpAeW"
let POPULAR_SHARED_URL = "mostpopular/v2/shared/1/facebook.json?api-key=\(API_KEY_NYT)"
let POPULAR_EMAILED_URL = "mostpopular/v2/emailed/7.json?api-key=\(API_KEY_NYT)"
let POPULAR_VIEWED_URL = "mostpopular/v2/viewed/1.json?api-key=\(API_KEY_NYT)"
let SEARCH_URL = "search/v2/articlesearch.json?q=%@&page=%@&sort=oldest&api-key=\(API_KEY_NYT)"

enum PopularCategory: Int {
    case MOST_VIEWED = 0, MOST_SHARED, MOST_EMAILED
}

let PAGE_LIMIT = 10
let DATE_FORMAT = "YYYY-MM-dd"

// -- Constant String Messages
let SERVER_ERROR_MSG = "Unable to connect to the server.\nPlease try again later."
let NO_NETWORK_ERROR_MSG = "You are currently offline. Please connect to internet."
