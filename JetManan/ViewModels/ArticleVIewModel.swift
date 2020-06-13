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
//    private var totalPage:Int = 1
    public var lastpagedReached:Bool = false
    
    //MARK:- Parse the URL Data
    func getArticleResponse(page:Int, completion: (()-> Void)?){
        networkManager.performNetworkTask(endpoint: APIData.repository(page: page), type: [ArticleDetailModel].self) { [weak self](response) in
            
            if response.count > 0 {
                if(page == 1) {
                    self?.repoDataItem =  response
                }
                else{
                    let repoDataItem = self?.repoDataItem
                    self?.repoDataItem = repoDataItem! + response
                }
                self?.lastpagedReached = false
                
                for articleDetailModel in response {
                    CoreDataManager.sharedManager.insertArticle(article: articleDetailModel)
                }
            }
            
            if response.count < 10 {
                self?.lastpagedReached = true
            } else {
                self?.lastpagedReached = false
            }
            completion?()
        }
    }
    
    func getArticleResponse(articleDetailCD : [ArticleDetail], completion: (()-> Void)?) {
        var arrArticleDetailModel : [ArticleDetailModel] = []
        for articleCD in articleDetailCD {
            var media : [ArticleMediaModel] = []
            if let mediaData = articleCD.media as? Data {
                media = mediaData.compactMap{ _ in return ArticleMediaModel(data: mediaData) }
            }
            
            var user : [ArticleUserModel] = []
            if let userData = articleCD.user as? Data {
                user = userData.compactMap{ _ in return ArticleUserModel(data: userData) }
            }
            
            // let user = NSKeyedUnarchiver.unarchiveObject(with: articleCD.user as! Data)
            let articleDetailModel =  ArticleDetailModel(id: articleCD.id!, createdAt: articleCD.createdAt!, content: articleCD.content!, comments: Int(articleCD.comments), likes: Int(articleCD.likes), media: media, user: user)
            arrArticleDetailModel.append(articleDetailModel)
        }
        self.repoDataItem = arrArticleDetailModel
        self.lastpagedReached = true
        completion?()
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
//        totalPage = totalData/(self.repoDataItem.count )
    }
    //MARK:- Data for views
    public func dataAtIndexPath(_ indexPath:IndexPath) -> ArticleDetailModel{
        return repoDataItem[indexPath.row]
    }
}
