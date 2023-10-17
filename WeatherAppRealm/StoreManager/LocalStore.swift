//
//  LocalStore.swift
//  WeatherApp
//
//  Created by apple on 10/3/23.
//

import Foundation
import SwiftUI

class LocalStore{
    static let shared = LocalStore()
    @Published var isFetchingWeather: Bool = false
    @Published var weatherData: WeatherModel?

    internal init() { }
    func getWeatherData() -> WeatherModel? {
        self.isFetchingWeather = true
        if let jsonURL = Bundle.main.url(forResource: "modelData2", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let decoder = JSONDecoder()
                let weatherModel = try decoder.decode(WeatherModel.self, from: jsonData)
                self.weatherData = weatherModel
                self.isFetchingWeather = false
            } catch {
                print("Error loading and saving JSON data: \(error)")
            }
        }
        else
        {
            print("JSON file not found")
        }
        return weatherData
    }
    
    
}
