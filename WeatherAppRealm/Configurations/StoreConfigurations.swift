//
//  StoreConfigurations.swift
//  WeatherApp
//
//  Created by apple on 10/3/23.
//

import Foundation

class ConfigManager: ObservableObject
{
    @Published var config: storeConfig = .remote
    init(){
        checkConnection()
    }
    func checkConnection(){
        let connected = Reachability.isConnectedToNetwork()
        if connected {
            config = .remote
        }
        else {
            config = .local
        }
    }
    
}


enum storeConfig {
 case remote , local
    
}


