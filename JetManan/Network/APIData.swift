//
//  APIData.swift
//  JetManan
//
//  Created by techjini on 12/06/20.
//  Copyright © 2020 ms. All rights reserved.
//
import Foundation
enum APIData{
    case repository(page:Int)
}
//MARK:- Base URL Declairations
extension APIData: URLData {
    var baseURL: URL {
        return URL(string: "https://5e99a9b1bc561b0016af3540.mockapi.io")!
    }
    var path: String {
        switch self {
        case .repository(let page):
            return "/jet2/api/v1/blogs?page=\(page)&limit=10"
        }
    }
}
