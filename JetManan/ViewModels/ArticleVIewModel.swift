//
//  ArticleVIewModel.swift
//  JetManan
//
//  Created by Sameer on 12/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import Foundation
class  ArticleViewModel {
    //MARK:- Variable Declairations
    private var networkManager = NetworkManager()
//    private var repos: ArticleDataModel?
    private var repoDataItem: [ArticleDetailModel] = [ArticleDetailModel]()
    public var formattedTimeString: String?
    public var lastpagedReached:Bool = false
    
    //MARK:- Fetch article detail from API and parse data
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
    
    //MARK:- Fetch article detail from Core Data
    func getArticleResponse(articleDetailCD : [ArticleDetail], completion: (()-> Void)?) {
        var arrArticleDetailModel : [ArticleDetailModel] = []
        for articleCD in articleDetailCD {
            var media : Any? = nil
            var user : Any? = nil
            if let aMedia = articleCD.media {
                media  = NSKeyedUnarchiver.unarchiveObject(with: aMedia as! Data)
            }
            if let aUser = articleCD.user {
                user = NSKeyedUnarchiver.unarchiveObject(with: aUser as! Data)
            }

            let articleDetailModel =  ArticleDetailModel(id: articleCD.id!, createdAt: articleCD.createdAt!, content: articleCD.content!, comments: Int(articleCD.comments), likes: Int(articleCD.likes), media: media as? [ArticleMediaModel], user: user as? [ArticleUserModel])
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
  
    //MARK:- Data for views
    public func dataAtIndexPath(_ indexPath:IndexPath) -> ArticleDetailModel{
        return repoDataItem[indexPath.row]
    }
}
