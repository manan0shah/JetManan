//
//  ArticleVIewModel.swift
//  JetManan
//
//  Created by techjini on 12/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import Foundation
class  ArticleViewModel {
    //MARK:- Variable Declairations
    private var networkManager = NetworkManager()
//    private var repos: ArticleDataModel?
    private var repoDataItem: [ArticleDetailModel] = [ArticleDetailModel]()
    public var formattedTimeString: String?
    private var  totalData:Int = 1
    private var totalPage:Int = 1
    public var lastpagedReached:Bool = false
    
    //MARK:- Parse the URL Data
    func getArticleResponse(page:Int, completion: (()-> Void)?){
        networkManager.performNetworkTask(endpoint: APIData.repository(page: page), type: [ArticleDetailModel].self) { [weak self](response) in
            self?.repoDataItem =  response
            if page <= self?.totalPage ?? 1 {
                if(page == 1){
                 
                }
                else{
                    let repoDataItem =  self?.repoDataItem
                    self?.repoDataItem = repoDataItem!
                }
                self?.lastpagedReached = false
            }
            else{
                self?.lastpagedReached = true
                return
            }
            completion?()
        }
    }
    //MARK:- total data count
    public var Count: Int {
        return repoDataItem.count
    }
   
    
    //MARK:- Check pagination data for the page
    public var isLastPage: Bool {
        return self.lastpagedReached
    }
    //MARK:- Remove Data from model
    public func removeAllData(){
        repoDataItem.removeAll()
    }
    //MARK:- Calculate total page, Data count in single page.
    public func pageData(){
        totalData = Int("1") ?? 1
        totalPage = totalData/(self.repoDataItem.count )
    }
    //MARK:- Data for views
    public func dataAtIndexPath(_ indexPath:IndexPath) -> ArticleDetailModel{
        return repoDataItem[indexPath.row]
    }
}
