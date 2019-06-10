//
//  ArticleListViewController.swift
//  NYT
//
//  Created by Rahul Dange on 4/11/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import UIKit

class ArticleListViewController: UIViewController {

    // -- Outlets
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var noArticlesLabel: UILabel!
    
    // -- variables
    private let articleViewModel: ArticleViewModel? = ArticleViewModel()
    private var isPaginationRequired: Bool = false
    private var popularCat: PopularCategory?
    private var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Articles"
        // -- Hide extra tableview lines
        self.articlesTableView.tableFooterView = UIView()
        // -- Load UI
        self.loadUI()
    }
    
    // MARK: - Internal Methods -
    func loadUI() {
        // -- call API and load Articles
        if isPaginationRequired { // -- call search Articles API
            self.fetchSearchArticlesAndManage(withLoading: true)
        } else { //-- call popular categories API
           self.fetchPopularArticlesAndManage()
        }
    }
    
    func setSearchText(searchText: String) {
        self.searchText = searchText
    }
    
    func setPopularCat(popularCat: PopularCategory) {
        self.popularCat = popularCat
    }
    
    func setIsPaginationRequired(required: Bool) {
        self.isPaginationRequired = required
    }
    
    func configureCell(cell: SearchTableViewCell, indexPath: IndexPath) {
        if let currentArticleModel = self.articleViewModel?.getArticlesArray()[indexPath.row] {
            cell.titleLabel?.text = currentArticleModel.title
            cell.subtitleLabel?.text = currentArticleModel.publishedDate
        }
    }
}

// MARK: - Extension - Table View Data source nd delegate methods  -
extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModel?.getArticlesArray().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! SearchTableViewCell
        // -- setting Article values as title and published date
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 70.0
        
        if let currentArticleModel = self.articleViewModel?.getArticlesArray()[indexPath.row] {
            let size = Utility.getBoudingRectForText(text: currentArticleModel.title, font: UIFont.systemFont(ofSize: 17.0), boundingRect: .init(width: self.view.bounds.width - 40, height: CGFloat(MAXFLOAT)))
            cellHeight = size.height + 35.0
        }
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isPaginationRequired {
            if indexPath.row == (articleViewModel?.getArticlesArray().count)! - 5 && (articleViewModel?.getPagingIndex())! > -1 {
                // -- call next page Articles
                self.fetchSearchArticlesAndManage(withLoading: false)
            }
        }
    }
}

// MARK: - API Call response handling -
extension ArticleListViewController {
    func fetchPopularArticlesAndManage() {
        Utility.showActivityIndicatory((self.parent?.view)!)
        articleViewModel?.fetchPopularArticles(popularCat: self.popularCat!, completion: { [weak self] (result) in
            DispatchQueue.main.async {
                Utility.hideActivityIndicatory((self?.parent?.view)!)
                if result.count == 0 {
                    self?.articlesTableView.reloadData()
                } else {
                    Utility.showAlert(self, title: "Error", message: result)
                }
                self?.noArticlesLabel.isHidden = result.count == 0 ? true : false
            }
        })
    }
    
    func fetchSearchArticlesAndManage(withLoading: Bool) {
        // -- show loading only for first time
        if withLoading {
            Utility.showActivityIndicatory((self.parent?.view)!)
        }
        articleViewModel?.fetchSearchArticles(searchText: self.searchText ?? "", completion: { [weak self] (result) in
            DispatchQueue.main.async {
                if withLoading {
                    Utility.hideActivityIndicatory((self?.parent?.view)!)
                }
                if result.count == 0 {
                    self?.articlesTableView.reloadData()
                } else {
                    Utility.showAlert(self, title: "Error", message: result)
                }
                self?.noArticlesLabel.isHidden = self?.articleViewModel?.getArticlesArray().count == 0 ? false : true
            }
        })
    }
}
