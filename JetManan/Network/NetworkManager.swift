//
//  NetworkManager.swift
//  JetManan
//
//  Created by techjini on 12/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import Foundation
struct NetworkManager {
    //MARK:- Perform Network Task via URLSession
    func performNetworkTask<T: Codable>(endpoint: APIData,
                                        type: T.Type,
                                        completion: ((_ response: T) -> Void)?) {
        let urlString = endpoint.baseURL.appendingPathComponent(endpoint.path).absoluteString.removingPercentEncoding
        guard let urlRequest = URL(string: urlString ?? "") else { return }
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "GET"
        let urlSession = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let _ = error {
                return
            }
            guard let data = data else {
                return
            }
            let response = Response(data: data)
            guard let decoded = response.decode(type) else {
                return
            }
            completion?(decoded)
        }
        urlSession.resume()
    }
    
}
