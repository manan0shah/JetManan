//
//  ArticleVC.swift
//  JetManan
//
//  Created by techjini on 11/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import UIKit

class ArticleVC: UIViewController {

    @IBOutlet weak var tableViewArticle: UITableView!
    //MARK:- Variable Declairations
    private var viewModel =  ArticleViewModel()
    var currentPage: Int = 1
    var endPage: Int = 1
    let loading = UIActivityIndicatorView()
    var isNextPage: Bool = false
    var isLastPageReached: Bool = false
    var isLoadMore: Bool = true
    var isNextPageCallInprogress: Bool = false
    
    //MARK:- Variable Declairations
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.refreshList(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    var expectedWidth: CGFloat {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if  (windowScene?.interfaceOrientation == .portrait || windowScene?.interfaceOrientation == .portraitUpsideDown) && (windowScene?.activationState == .foregroundActive)  {
            return ((UIScreen.main.bounds.width - 45) / 2)
        }
        return ((UIScreen.main.bounds.width - 90) / 3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewArticle.estimatedRowHeight = 40
        self.tableViewArticle.rowHeight = UITableView.automaticDimension
        self.tableViewArticle.tableFooterView = UIView()
        self.tableViewArticle.contentInset = .zero
        initialSetup()
    }
    
    //MARK:- Fetchiching ViewModelData, Register cell nib
    private func initialSetup() {
        self.edgesForExtendedLayout = UIRectEdge.bottom
        ArticleDetailCell.registerCell(for: tableViewArticle)
        tableViewArticle.addSubview(refreshControl)
        if Reachability.shared.isReachable {
            viewModel.getArticleResponse(page: currentPage) { [weak self] in
                DispatchQueue.main.async {
                    self?.tableViewArticle.reloadData()
                    self?.viewModel.pageData()
                }
            }
        } else {
            
            if let articleDetailsCD =  CoreDataManager.sharedManager.fetchAllArticles() {
                viewModel.getArticleResponse(articleDetailCD: articleDetailsCD) { [weak self] in
                    self?.tableViewArticle.reloadData()
                    self?.viewModel.pageData()
                }
            }
        }
    }
    
    //MARK:- Add pagination call
    func loadMore(){
        currentPage = currentPage+1
        viewModel.getArticleResponse(page: currentPage) { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewArticle.reloadData()
            }
        }
    }
    
    // Pull to refresh action
    @objc private func refreshList(_ refreshControl: UIRefreshControl) {
        tableViewArticle.reloadData()
        currentPage = 1
        viewModel.getArticleResponse (page: currentPage) { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewArticle.reloadData()
//                refreshControl.endRefreshing()
            }
        }
    }
}

extension ArticleVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.Count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleDetailCell", for: indexPath) as! ArticleDetailCell
        cell.cellData(at: indexPath, with: self.viewModel.dataAtIndexPath(indexPath))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = self.viewModel.Count - 1
        if indexPath.row == lastRow && !self.isLastPageReached {
            currentPage = currentPage + 1
            viewModel.getArticleResponse (page: currentPage) { [weak self] in
                DispatchQueue.main.async {
                    self?.tableViewArticle.reloadData()
                    self?.isLastPageReached = self?.viewModel.lastpagedReached ?? false
                }
            }
        }
    }
}

extension ArticleVC : ArticleDetailCellDelegate {
    func urlTapped(urlString: String) {
        if let urlUsed = URL(string: urlString) {
            UIApplication.shared.open(urlUsed)
        }
    }
}
