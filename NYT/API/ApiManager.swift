//
//  ApiManager.swift
//  NYT
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation

enum RequestResult {
    case Success
    case Fail
    case NoInternet
    case TimeOut
    case Cancel
    case DataError
    case SessionExpired
    case Outdated
    case InvalidLogin
    case ServerError
    case CommonKeyFailed
}

class APIManager {
    
    // -- Search articles API
    func getSearchArticles(withSearchText: String, index: Int, completion: @escaping (_ searchArticlesModel: SearchArticlesModel?, _ result: RequestResult?) -> Void) {
        let searchUrl = String.init(format: SEARCH_URL, withSearchText, "\(index)")

        // -- call and convert data
        self.getJSONFromURL(urlString: SERVER_URL + searchUrl) { (data, result) in
            guard let data = data else {
                print("Failed to get data")
                return completion(nil, result)
            }
            self.createSearchArticleObjectWith(json: data, completion: { (searchModels, error) in
                return completion(searchModels, error)
            })
        }
    }
    
    // -- Get popular Articles API
    func getPopularArticles(popularCat: PopularCategory, completion: @escaping (_ popularArticlesModel: PopularArticlesModel?, _ result: RequestResult?) -> Void) {
        var popularUrl = SERVER_URL
        
        // -- select correct url
        switch popularCat {
        case .MOST_EMAILED:
            popularUrl = popularUrl + POPULAR_EMAILED_URL
            break
            
        case .MOST_SHARED:
            popularUrl = popularUrl + POPULAR_SHARED_URL
            break
            
        case .MOST_VIEWED:
            popularUrl = popularUrl + POPULAR_VIEWED_URL
            break
        }
        
        // -- call and convert data
        self.getJSONFromURL(urlString: popularUrl) { (data, error) in
            guard let data = data else {
                print("Failed to get data")
                return completion(nil, error)
            }
            self.createPopularArticleObjectWith(json: data, completion: { (popularModels, error) in
                return completion(popularModels, error)
            })
        }
    }
}

extension APIManager {
    
    // -- call get API to receive data
    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ result: RequestResult?) -> Void) {
        if NetworkReachability.sharedInstance.isNetworkAvailable() {
            guard let url = URL(string: urlString) else {
                print("Error: Cannot create URL from string")
                return
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard error == nil else {
                    print("Error calling api")
                    return completion(nil, .DataError)
                }
                guard let responseData = data else {
                    print("Data is nil")
                    return completion(nil, .DataError)
                }
                completion(responseData, .Success)
            }
            task.resume()
        } else {
            completion(nil, .NoInternet)
        }
    }
    
    // -- Create SearchArticlesModel from data received using network call
    private func createSearchArticleObjectWith(json: Data, completion: @escaping (_ data: SearchArticlesModel?, _ result: RequestResult?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let searchArticlesModel = try decoder.decode(SearchArticlesModel.self, from: json)
            return completion(searchArticlesModel, .Success)
        } catch let error {
            print(">>> Error creating current search articles from JSON because: \(error.localizedDescription)")
            return completion(nil, .DataError)
        }
    }
    
    // -- Create PopularArticlesModel from data received using network call
    private func createPopularArticleObjectWith(json: Data, completion: @escaping (_ data: PopularArticlesModel?, _ result: RequestResult?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let popularArticlesModel = try decoder.decode(PopularArticlesModel.self, from: json)
            return completion(popularArticlesModel, .Success)
        } catch let error {
            print(">>> Error creating current popular articles from JSON because: \(error.localizedDescription)")
            return completion(nil, .DataError)
        }
    }
}
