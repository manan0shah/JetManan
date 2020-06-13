//
//  CoreDataManager.swift
//  JetManan
//
//  Created by techjini on 13/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()

    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
      
      let container = NSPersistentContainer(name: "JetManan")
      
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    func saveContext () {
      let context = CoreDataManager.sharedManager.persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
    
    func insertArticle(article: ArticleDetailModel) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ArticleDetail",
                                                in: managedContext)!
        
        let articleObj = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        articleObj.setValue(article.id, forKeyPath: "id")
        articleObj.setValue(article.content, forKeyPath: "content")
        articleObj.setValue(article.createdAt, forKey: "createdAt")
        articleObj.setValue(article.likes, forKeyPath: "likes")
        articleObj.setValue(article.comments, forKey: "comments")
        articleObj.setValue(article.media?.map{ $0.encode() }, forKey: "media")
        articleObj.setValue(article.user.map{ $0.encode() }, forKey: "user")
        
//        do {
//            let mediaData = try NSKeyedArchiver.archivedData(withRootObject: article.media.enc, requiringSecureCoding: true)
//            articleObj.setValue(mediaData, forKey: "media")
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
//        do {
//            let userData = try NSKeyedArchiver.archivedData(withRootObject: article.user, requiringSecureCoding: false)
//            articleObj.setValue(userData, forKey: "user")
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return
        }
    }

    func fetchAllArticles() -> [ArticleDetail]?{
      
      let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
      
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArticleDetail")
      
      do {
        let articles = try managedContext.fetch(fetchRequest)
        return articles as? [ArticleDetail]
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return nil
      }
    }
}
