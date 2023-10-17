//
//  StoreManager.swift
//  WeatherApp
//
//  Created by apple on 10/3/23.
//

import Foundation
import Alamofire
import SwiftUI

class StoreManager : ObservableObject{
    
    static let shared = StoreManager()
    
    let configManager = ConfigManager()
    
    @Published var weatherData: WeatherModel?
    
    @Published var cityName: String = "Karachi"
    @Published var isFetchingWeather = false
    
    @AppStorage ("selected-unit") var selectedUnit = Units.metric
    @AppStorage("lastCity") var lastCity: String = ""
    
    internal init() {}
    
    func getWeather()  -> WeatherModel? {
        switch configManager.config {
        case .remote:
                self.isFetchingWeather = true
                let params: Parameters = [
                    "q":  self.cityName,
                    "appid": Constants.shared.API_Key,
                    "units": self.selectedUnit.rawValue
                ]
                
                RemoteStore.shared.getWeatherByCityName(params:params){ response in
                    self.weatherData = response
                    self.isFetchingWeather = false
                    self.lastCity = self.cityName
                    
                    
                } failure: { error in
                    print(error)
                }
                return weatherData
                
        case .local:
                weatherData =  LocalStore.shared.getWeatherData()
                return  weatherData
        }
    }
}
enum Units: String {
    case metric = "metric"
    case imperial = "imperial"
    case standard = "standard"
}
