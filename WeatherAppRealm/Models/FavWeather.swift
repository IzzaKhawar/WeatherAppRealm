//
//  FavWeather.swift
//  WeatherAppRealm
//
//  Created by apple on 10/13/23.
//

import Foundation
import RealmSwift

class FavWeather: Object , Identifiable {
    
    @Persisted var id : ObjectId
    @Persisted(primaryKey: true) var city : String

    override class func primaryKey() -> String? {
        "city"
    }
    
}
