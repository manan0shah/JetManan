//
//  URLData.swift
//  JetManan
//
//  Created by techjini on 12/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import Foundation
//MARK:- BAse URL Protocol
protocol URLData {
    var baseURL: URL { get }
    var path: String { get }
}
