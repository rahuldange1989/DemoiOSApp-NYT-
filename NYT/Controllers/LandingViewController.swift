//
//  LandingViewController.swift
//  NYT
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    // -- Outlets
    @IBOutlet weak var optionsTableView: UITableView!
    
    // -- variables
    var sectionTitles: [String] = ["Search", "Popular"] // -- Initialize Section titles
    var optionsValues: [[String]] = [["Search Articles"], ["Most Viewed", "Most Shared", "Most Emailed"]]
    var articleListVC: ArticleListViewController?
    var searchArticleVC: SearchArticleViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Internal Methods -
    func navigateToArticles(popularCat: PopularCategory) {
        articleListVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticleListViewController") as? ArticleListViewController
        articleListVC?.setPopularCat(popularCat: popularCat)
        articleListVC?.setIsPaginationRequired(required: false)
        self.navigationController?.pushViewController(articleListVC!, animated: true)
    }
    
    func navigateToSearchArticles() {
        searchArticleVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchArticleViewController") as? SearchArticleViewController
        self.navigationController?.pushViewController(searchArticleVC!, animated: true)
    }
}

// MARK: - Extension - Table View Data source nd delegate methods  -
extension LandingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsValues[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        // -- setting cell label from options available
        cell.textLabel?.text = optionsValues[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // -- Search article if section is 0
            self.navigateToSearchArticles()
        } else {
            // -- Popular if section is 1
            let popularCat = PopularCategory.init(rawValue: indexPath.row)
            self.navigateToArticles(popularCat: popularCat!)
        }
    }
}
