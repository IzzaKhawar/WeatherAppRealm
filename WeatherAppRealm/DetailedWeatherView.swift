//
//  WeatherView.swift
//  WeatherApp
//
//  Created by apple on 9/27/23.
//
import SwiftUI

struct WeatherView: View {
    @State var modelData: WeatherModel?
    @State var selectedUnits: Units?
    @State private var isSaved: Bool = false
    var body: some View {
        NavigationView{
           
                VStack (spacing: -4){
                    if let model = modelData, let unitSelected = selectedUnits {
                        WeatherHeader(model: model, selectedUnits: unitSelected)
                        
                        HourlyForecast(model: model , selectedUnits: unitSelected)
                        
                        DailyForecast(model: model, selectedUnits: unitSelected)
                        
                            .background(Color.grayish)
                            .cornerRadius(15.0)
                            .padding()
                        
                        
                    } else {
                        Text("Data Not Loaded")
                            .fontWeight(.bold)
                            .font(.headline)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.color, Color.liner]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea([.top, .bottom])
                )
                .foregroundColor(.white)
            
            
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {

                Button {
                    if isSaved {
                        if let id = modelData?.city?.name {
                            isSaved = !DataManager.sharedInstance.deleteFavWeather(name: id)
                        }
                    } else {
                        if let name = modelData?.city?.name {
                            isSaved = DataManager.sharedInstance.saveFavWeather(name)
                        }
                    }
                }
                    label: {
                        HStack {
                            Text("Fav List")
                            if isSaved {
                                Image(systemName: "heart.fill")
                            }
                            else{
                                Image(systemName: "heart")
                            }
                                
                        }
                    }

            }
        }
        
    }
}

struct WeatherHeader: View {
    var model: WeatherModel
    let selectedUnits: Units
    var body: some View {
        VStack(alignment: .center) {
            Text(model.city?.name ?? "")
                .font(.system(size: 34))
                .fontWeight(.bold)
            
            Text("\(model.list?.first?.main?.temp ?? "0")\(selectedUnits == .metric ? "°C" : "°F")")
            
            Text(model.list?.first?.weather?.first?.description ?? "")
            
            Text("H: \(Int(Double(model.list?.first?.main?.temp_max ?? "0") ?? 0))\(selectedUnits == .metric ? "°C" : "°F") - L: \(Int(Double(model.list?.first?.main?.temp_min ?? "0") ?? 0))\(selectedUnits == .metric ? "°C" : "°F")")
                .font(.footnote)
                .font(.headline)
        }
        
    }
}



struct DailyForecast: View {
    var model: WeatherModel
    let selectedUnits: Units
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            Label("6-Days FORECAST", systemImage: "calendar")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .padding([.top, .leading], 10)
            
            Divider()
                .background(Color.primary)
                .padding([.leading, .trailing], 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(model.dailyWeather, id: \.date) { dailyData in
                        DailyWeatherView(dailymodel: dailyData , selectedUnits: selectedUnits)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.grayish)
        .cornerRadius(15.0)
        .padding()
    }
}


struct DailyWeatherView: View {
    var dailymodel: DailyWeather
    let selectedUnits: Units
    var body: some View {
        
        HStack {
            Text("\(dailymodel.date)")
                .font(.subheadline)
            
            Spacer()
                .frame(width: 30 , height: 35)
            
            Image(systemName: "\(dailymodel.weatherMain)".lowercased())
                .foregroundColor(.white)
            Spacer()
                .frame(width: 30 , height: 35)
            
            Text("\(dailymodel.minTemperature )\(selectedUnits == .metric ? "°C" : "°F" ) - \(dailymodel.maxTemperature  )\(selectedUnits == .metric ? "°C" : "°F")" )
        }
        Divider()
        
        
    }
}


struct HourlyForecast: View {
    var model: WeatherModel
    let selectedUnits: Units
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            
            Label("48-HOUR FORECAST", systemImage: "clock")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .padding([.top, .leading], 10)
            
            Divider()
                .background(Color.primary)
                .padding([.leading, .trailing], 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(model.hourlyWeather, id: \.timestamp) { hourlyData in
                        HourlyWeatherView(hourlyData: hourlyData,selectedUnits: selectedUnits)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.grayish)
        .cornerRadius(15.0)
        .padding()
    }
}

struct HourlyWeatherView: View {
    var hourlyData: HourlyWeather
    let selectedUnits: Units
    var body: some View {
        VStack {
            Text(String(hourlyData.timestamp))
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
                .frame(width: 15 , height: 25)
            
            Image(systemName: "\(hourlyData.weatherMain)".lowercased())
                .foregroundColor(.white)
            Spacer()
                .frame(width: 15 , height: 25)
            Text("\(hourlyData.temperature)\(selectedUnits == .metric ? "°C" : "°F")")
        }
        .padding(.vertical)
        .frame(width: 80)
        
    }
}


#Preview {
    WeatherView( selectedUnits: Units.metric )
}
