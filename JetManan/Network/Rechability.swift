//
//  Rechability.swift
//  JetManan
//
//  Created by techjini on 13/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import Foundation
import Alamofire

class Reachability: NSObject {
    public static var shared: NetworkReachabilityManager = {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown:
                print("It is unknown wether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the cellular connection")
            }
        })
        
        return reachabilityManager!
    }()
}
