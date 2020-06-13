//
//  ArticleDetail+CoreDataProperties.swift
//  
//
//  Created by techjini on 13/06/20.
//
//

import Foundation
import CoreData


extension ArticleDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleDetail> {
        return NSFetchRequest<ArticleDetail>(entityName: "ArticleDetail")
    }

    @NSManaged public var id: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var content: String?
    @NSManaged public var comments: Int64
    @NSManaged public var likes: Int64
    @NSManaged public var media: NSObject?
    @NSManaged public var user: NSObject?

}
