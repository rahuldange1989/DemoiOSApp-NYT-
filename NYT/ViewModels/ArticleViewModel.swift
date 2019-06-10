//
//  ArticleViewModel.swift
//  NYT
//
//  Created by Rahul Dange on 4/11/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation

class ArticleViewModel {
    
    // -- Variables
    private var pagingIndex: Int = 0
    private var articleModelsArray: [PopularArticleModel] = []
    private var apiManager = APIManager()
    
    // MARK: - Internal Methoda -
    func fetchPopularArticles(popularCat: PopularCategory, completion: @escaping (_ message: String) -> ()) {
        apiManager.getPopularArticles(popularCat: popularCat) { [weak self] (models, result) in
            if result == .Success {
                self?.articleModelsArray = models?.results ?? []
                completion("")
            } else if result == .NoInternet {
                completion(NO_NETWORK_ERROR_MSG)
            } else{
                completion(SERVER_ERROR_MSG)
            }
        }
    }
    
    func fetchSearchArticles(searchText: String, completion: @escaping (_ message: String) -> ()) {
        apiManager.getSearchArticles(withSearchText: searchText, index: self.pagingIndex) { (searchModel, result) in
            if result == .Success {
                let tempArray = self.createArticleModelFromDocsModel(docModels: searchModel?.response.docs ?? [])
                if tempArray.count > 0 {
                    self.articleModelsArray.append(contentsOf: tempArray)
                }
                // -- update UI with closure
                completion("")
                // -- update paging index
                if tempArray.count < PAGE_LIMIT {
                    self.pagingIndex = -1
                } else {
                    self.pagingIndex = self.pagingIndex + 1
                }
            } else if result == .NoInternet {
                completion(NO_NETWORK_ERROR_MSG)
            } else{
                completion(SERVER_ERROR_MSG)
            }
        }
    }
    
    func createArticleModelFromDocsModel(docModels: [Docs]) -> [PopularArticleModel] {
        var articleModels: [PopularArticleModel] = []
        for model in docModels {
            let dateInFormat = Utility.getDateStringFrom(isoDateString: model.pubDate)
            let articleModel = PopularArticleModel(title: model.headline.main, publishedDate: dateInFormat)
            articleModels.append(articleModel)
        }
        return articleModels
    }
}

// MARK: - Getter Setter methods-
extension ArticleViewModel {
    
    func getPagingIndex() -> Int {
        return self.pagingIndex
    }
    
    func getArticlesArray() -> [PopularArticleModel] {
        return self.articleModelsArray
    }
}
