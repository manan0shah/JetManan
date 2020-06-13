//
//  ArticleDetailModel.swift
//  JetManan
//
//  Created by techjini on 12/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import Foundation

struct ArticleDetailModel : Codable {
    let id: String
    let createdAt: String
    let content: String
    let comments : Int
    let likes : Int
    let media : [ArticleMediaModel]?
    let user : [ArticleUserModel]
}
 
struct ArticleMediaModel : Codable  {
    var id : String
    var blogId : String
    var createdAt : String
    var image : String?
    var title : String
    var url : String?
}

extension ArticleMediaModel {
    func encode() -> Data {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(id, forKey: "id")
        archiver.encode(blogId, forKey: "blogId")
        archiver.encode(createdAt, forKey: "createdAt")
        archiver.encode(image, forKey: "image")
        archiver.encode(title, forKey: "title")
        archiver.encode(url, forKey: "url")
        archiver.finishEncoding()
        return data as Data
    }
    
    init?(data: Data) {
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            
            defer {
                unarchiver.finishDecoding()
            }
            guard let blogId = unarchiver.decodeObject(forKey: "blogId") as? String else { return nil }
            guard let id = unarchiver.decodeObject(forKey: "id") as? String else { return nil }
            guard let createdAt = unarchiver.decodeObject(forKey: "createdAt") as? String else { return nil }
            guard let image = unarchiver.decodeObject(forKey: "image") as? String else { return nil }
            guard let title = unarchiver.decodeObject(forKey: "title") as? String else { return nil }
            guard let url = unarchiver.decodeObject(forKey: "url") as? String else { return nil }
            
            self.id = id
            self.blogId = blogId
            self.createdAt = createdAt
            self.image = image
            self.title = title
            self.url = url
        } catch let error {
            self.id = ""
            self.blogId = ""
            self.createdAt = ""
            self.image = ""
            self.title = ""
            self.url = ""
            print(error.localizedDescription)
        }
    }
}

struct ArticleUserModel : Codable {
    let id : String
    let blogId : String
    let createdAt : String
    let name : String
    let avatar : String?
    let lastname : String
    let city : String
    let designation : String
    let about : String
}

extension ArticleUserModel {
    func encode() -> Data {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(id, forKey: "id")
        archiver.encode(blogId, forKey: "blogId")
        archiver.encode(createdAt, forKey: "createdAt")
        archiver.encode(name, forKey: "name")
        archiver.encode(avatar, forKey: "avatar")
        archiver.encode(lastname, forKey: "lastname")
        archiver.encode(city, forKey: "city")
        archiver.encode(designation, forKey: "designation")
        archiver.encode(about, forKey: "about")
        archiver.finishEncoding()
        return data as Data
    }
    
    init?(data: Data) {
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            
            defer {
                unarchiver.finishDecoding()
            }
            guard let blogId = unarchiver.decodeObject(forKey: "blogId") as? String else { return nil }
            guard let id = unarchiver.decodeObject(forKey: "id") as? String else { return nil }
            guard let createdAt = unarchiver.decodeObject(forKey: "createdAt") as? String else { return nil }
            guard let name = unarchiver.decodeObject(forKey: "name") as? String else { return nil }
            guard let avatar = unarchiver.decodeObject(forKey: "avatar") as? String else { return nil }
            guard let lastname = unarchiver.decodeObject(forKey: "lastname") as? String else { return nil }
            guard let city = unarchiver.decodeObject(forKey: "city") as? String else { return nil }
            guard let designation = unarchiver.decodeObject(forKey: "designation") as? String else { return nil }
            guard let about = unarchiver.decodeObject(forKey: "about") as? String else { return nil }
            
            self.id = id
            self.blogId = blogId
            self.createdAt = createdAt
            self.name = name
            self.avatar = avatar
            self.lastname = lastname
            self.city = city
            self.designation = designation
            self.about = about
            
        } catch let error {
            self.id = ""
            self.blogId = ""
            self.createdAt = ""
            self.name = ""
            self.avatar = ""
            self.lastname = ""
            self.city = ""
            self.designation = ""
            self.about = ""
            print(error.localizedDescription)
        }
    }
}



struct  Response {
    fileprivate var data:Data
    init(data:Data) {
        self.data = data
    }
}
//MARK:- Decode response into model
extension Response{
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            return response
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
