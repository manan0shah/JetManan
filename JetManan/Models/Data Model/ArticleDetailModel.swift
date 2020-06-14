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
    let user : [ArticleUserModel]?
}

struct ArticleMediaModel : Codable  {
    var id : String
    var blogId : String
    var createdAt : String
    var image : String?
    var title : String
    var url : String?
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
