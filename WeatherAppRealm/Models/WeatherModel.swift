//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by apple on 9/30/23.
//



import Foundation
import SwiftUI

struct WeatherModel : Codable {
    let cod : String?
    let message : Int?
    let cnt : Int?
    let list : [List]?
    let city : City?
    var hourlyWeather: [HourlyWeather] {
        return list?.map { item in
            let timestamp: TimeInterval = TimeInterval(item.dt ?? 0)
            
            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"  // Use "HH:mm" for 24-hour format
            
            let formattedTime = dateFormatter.string(from: date)
            
            return HourlyWeather(
                date : item.dt ?? 0,
                timestamp: formattedTime,
                temperature: item.main?.temp ?? "0.0",
                weatherMain: item.weather?.first?.icon ?? ""
            )
        } ?? []
    }
    
    
    
    var dailyWeather: [DailyWeather] {
        let groupedByDate = Dictionary(grouping: hourlyWeather) { weather in
            let date = Date(timeIntervalSince1970: TimeInterval(weather.date ))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        }
        
        let sortedDates = groupedByDate.keys.sorted { (dateStr1, dateStr2) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let date1 = dateFormatter.date(from: dateStr1), let date2 = dateFormatter.date(from: dateStr2) {
                return date1 < date2
            }
            return false
        }
        
        var dailyWeatherArray: [DailyWeather] = []
        
        for key in sortedDates {
            if let value = groupedByDate[key] {
                let temperatures = value.compactMap { Double($0.temperature) }
                let minTemp = String(temperatures.min() ?? 0.0)
                let maxTemp = String(temperatures.max() ?? 0.0)
                
                let middleIndex = (value.count / 2) - 1
                let dailyWeatherItem = DailyWeather(
                    date: key,
                    minTemperature: minTemp,
                    maxTemperature: maxTemp,
                   
                    weatherMain: value[middleIndex].weatherMain
                )
                
                dailyWeatherArray.append(dailyWeatherItem)
            }
        }
        
        return dailyWeatherArray
    }
    
    
    enum CodingKeys: String, CodingKey {
        
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
        case hourlyWeather = "hourlyWeather"
        case dailyWeather = "dailyWeather"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cod = try values.decodeIfPresent(String.self, forKey: .cod)
        message = try values.decodeIfPresent(Int.self, forKey: .message)
        cnt = try values.decodeIfPresent(Int.self, forKey: .cnt)
        list = try values.decodeIfPresent([List].self, forKey: .list)
        city = try values.decodeIfPresent(City.self, forKey: .city)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cod, forKey: .cod)
        try container.encode(message, forKey: .message)
        try container.encode(cnt, forKey: .cnt)
        try container.encode(list, forKey: .list)
        try container.encode(city, forKey: .city)
        
    }
}

struct HourlyWeather : Identifiable,Codable {
    var id = UUID()
    let date : Int
    let timestamp: String
    let temperature: String
    let weatherMain: String
}

struct DailyWeather :Identifiable,Codable {
    var id = UUID()
    let date: String
    let minTemperature: String
    let maxTemperature: String
    let weatherMain: String
}

struct City : Codable {
    let id : Int?
    let name : String?
    let coord : Coord?
    let country : String?
    let population : Int?
    let timezone : Int?
    let sunrise : Int?
    let sunset : Int?
    
    enum CodingKeys: String, CodingKey {
           case id = "id"
           case name = "name"
           case coord = "coord"
           case country = "country"
           case population = "population"
           case timezone = "timezone"
           case sunrise = "sunrise"
           case sunset = "sunset"
       }

       init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           id = try container.decodeIfPresent(Int.self, forKey: .id)
           name = try container.decodeIfPresent(String.self, forKey: .name)
           coord = try container.decodeIfPresent(Coord.self, forKey: .coord)
           country = try container.decodeIfPresent(String.self, forKey: .country)
           population = try container.decodeIfPresent(Int.self, forKey: .population)
           timezone = try container.decodeIfPresent(Int.self, forKey: .timezone)
           sunrise = try container.decodeIfPresent(Int.self, forKey: .sunrise)
           sunset = try container.decodeIfPresent(Int.self, forKey: .sunset)
       }
    
}
struct Clouds : Codable {
    let all : Int?
    
    enum CodingKeys: String, CodingKey {

        case all = "all"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(Int.self, forKey: .all)
    }
}
struct Coord : Codable {
    let lat : Double?
    let lon : Double?
    
    enum CodingKeys: String, CodingKey {

        case lat = "lat"
        case lon = "lon"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
    }
}
struct List : Codable {
    let dt : Int?
    let main : Main?
    let weather : [Weather]?
    let clouds : Clouds?
    let wind : Wind?
    let visibility : Int?
    let pop : Double?
    let sys : Sys?
    let dt_txt : String?
    
    enum CodingKeys: String, CodingKey {
            case dt = "dt"
            case main = "main"
            case weather = "weather"
            case clouds = "clouds"
            case wind = "wind"
            case visibility = "visibility"
            case pop = "pop"
            case sys = "sys"
            case dt_txt = "dt_txt"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            dt = try container.decodeIfPresent(Int.self, forKey: .dt)
            main = try container.decodeIfPresent(Main.self, forKey: .main)
            weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
            clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds)
            wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
            visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
            pop = try container.decodeIfPresent(Double.self, forKey: .pop)
            sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
            dt_txt = try container.decodeIfPresent(String.self, forKey: .dt_txt)
        }
}

struct Main : Codable {
    let temp : String?
    let feels_like : Double?
    let temp_min : String?
    let temp_max : String?
    let pressure : Int?
    let sea_level : Int?
    let grnd_level : Int?
    let humidity : Int?
    let temp_kf : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case temp = "temp"
        case feels_like = "feels_like"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
        case pressure = "pressure"
        case sea_level = "sea_level"
        case grnd_level = "grnd_level"
        case humidity = "humidity"
        case temp_kf = "temp_kf"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let mainTemp = try values.decodeIfPresent(Double.self, forKey: .temp)
        feels_like = try values.decodeIfPresent(Double.self, forKey: .feels_like)
        let tempMin = try values.decodeIfPresent(Double.self, forKey: .temp_min)
        let tempMax = try values.decodeIfPresent(Double.self, forKey: .temp_max)
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
        sea_level = try values.decodeIfPresent(Int.self, forKey: .sea_level)
        grnd_level = try values.decodeIfPresent(Int.self, forKey: .grnd_level)
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
        temp_kf = try values.decodeIfPresent(Double.self, forKey: .temp_kf)
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")
        
        temp = formatter.string(from: NSNumber(value: mainTemp ?? 0)) ?? "0"
        temp_max = formatter.string(from: NSNumber(value: tempMax ?? 0)) ?? "0"
        temp_min = formatter.string(from: NSNumber(value: tempMin ?? 0)) ?? "0"
    }
    
}
struct Sys : Codable {
    let pod : String?
    
    enum CodingKeys: String, CodingKey {

        case pod = "pod"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pod = try values.decodeIfPresent(String.self, forKey: .pod)
    }
    
}
struct Weather : Codable {
    let id : Int?
    let main : String?
    let description : String?
    let icon : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        main = try values.decodeIfPresent(String.self, forKey: .main)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        if let decodedIcon = try values.decodeIfPresent(String.self, forKey: .icon) {
            
            switch decodedIcon {
                case "01d":
                    icon = "sun.max.fill"
                case "01n":
                    icon = "moon.fill"
                case "02d":
                    icon = "cloud.sun.fill"
                case "02n":
                    icon = "cloud.moon"
                case "03d":
                    icon =  "cloud"
                case "03n":
                    icon =  "cloud.fill"
                case "04d":
                    icon = "smoke"
                case "04n":
                    icon = "smoke.fill"
                case "09d":
                    icon = "cloud.rain"
                case "09n":
                    icon = "cloud.rain.fill"
                case "10d":
                    icon = "cloud.sun.rain"
                case "10n":
                    icon = "cloud.moon.rain"
                case "11d":
                    icon = "cloud.bolt.rain"
                case "11n":
                    icon = "cloud.bolt.rain.fill"
                case "13d":
                    icon = "snow"
                case "13n":
                    icon = "snowflake"
                case "50d":
                    icon = "tornado.circle"
                case "50n":
                    icon = "tornado.circle.fill"
                default:
                    icon = "sun.max.fill"
            }
        } else {
            icon = "sun.min"
        }
    }
    
}


struct Wind : Codable {
    let speed : Double?
    let deg : Int?
    let gust : Double?
    
    enum CodingKeys: String, CodingKey {

        case speed = "speed"
        case deg = "deg"
        case gust = "gust"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        deg = try values.decodeIfPresent(Int.self, forKey: .deg)
        gust = try values.decodeIfPresent(Double.self, forKey: .gust)
    }
    
}


struct FavWeathersCity {
    let id = UUID()
    let city : String?
}
