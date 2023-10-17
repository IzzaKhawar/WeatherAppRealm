//
//  HomeWeatherVM.swift
//  WeatherAppRealm
//
//  Created by apple on 10/13/23.
//

import Foundation
import  RealmSwift
import SwiftUI
//extension ContentView {
//    class ViewModel: ObservableObject {
//        init() {
//            getData()
//        }
//        @State var store = StoreManager.shared
//        @ObservedResults(FavWeather.self) var favWeather
//        
//        @State private var DATAMODEL: [WeatherModel] = []
//        private func getData() {
//            for fav in favWeather {
//                let cityName = fav.city
//                store.cityName = cityName
//                store.selectedUnit = Selection
//                store.getWeather(success: { weatherData in
//                    let modelData =  weatherData
//                    self.DATAMODEL.append(modelData)
//                    print("Model Data Added: \(modelData)")
//                },
//                failure: { error in
//                    print("Failed to fetch weather data for city: \(cityName) - Error: \(error)")
//                })
//            }
//            print("DATAMODEL: \(DATAMODEL)")
//        }
//    }
//    
//}
