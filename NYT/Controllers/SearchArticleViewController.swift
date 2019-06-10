//
//  SearchArticleViewController.swift
//  NYT
//
//  Created by Rahul Dange on 4/11/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import UIKit

class SearchArticleViewController: UIViewController {

    // -- Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    // -- variables
    var articleListVC: ArticleListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSearchField()
        self.title = "Search"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // -- to hide keyboard if user clicks outside
        self.view.endEditing(true)
    }
    
    // MARK: - Internal Methods -
    func setupSearchField() {
        let leftViewWithImage = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        let imageView = UIImageView.init(image: UIImage.init(named: "graySearch"))
        imageView.frame = CGRect.init(x: 7.5, y: 7.5, width: 15, height: 15)
        imageView.contentMode = .scaleAspectFit
        leftViewWithImage.addSubview(imageView)
        self.searchTextField.leftView = leftViewWithImage
        self.searchTextField.leftViewMode = UITextField.ViewMode.always
        self.searchTextField.layer.borderColor = UIColor.init(netHex: 0x808080).cgColor
        self.searchTextField.layer.borderWidth = 1.0
    }
    
    func navigateToArticles(searchText: String) {
        articleListVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticleListViewController") as? ArticleListViewController
        articleListVC?.setIsPaginationRequired(required: true)
        articleListVC?.setSearchText(searchText: searchText)
        self.navigationController?.pushViewController(articleListVC!, animated: true)
    }
    
    // MARK: - Event Handler Methods -
    @IBAction func searchBtnClicked(_ sender: Any) {
        // -- Hide keyboard
        self.searchTextField.resignFirstResponder()
        // -- make search string url encoding and then move to article list
        self.navigateToArticles(searchText: self.searchTextField.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? "")
    }
}
