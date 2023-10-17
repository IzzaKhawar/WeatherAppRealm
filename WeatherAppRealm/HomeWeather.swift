
//
//  ContentView.swift
//  WeatherApp
//
//  Created by apple on 9/27/23.
//
import SwiftUI
import UIKit
import RealmSwift

struct ContentView: View {
    
    @State var searchText = ""
    @State var isFetchingWeather : Bool = false
    let configManager = ConfigManager()
    @State var store = StoreManager.shared
    
    @ObservedResults(FavWeather.self) var favWeathers
    
    @State private var DATAMODEL: [WeatherModel] = []
    @State private var navigateToWeatherView = false
    @State private var Selection : Units = .metric
    @State private var isEditing = false
    
    @State private var cardToDelete: String? = nil
    @State var isDeleteButtonVisible :Bool = false
    @State private var isDeleted = false
    @Environment(\.realm) var realm
    init() {
        // Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        //        print(DATAMODEL.count)
        //        getData()
    }
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack {
                    HStack(alignment: .center, spacing: -6.0) {
                        TextField("Search for city", text: $searchText)
                            .padding(10.0)
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .submitLabel(.search)
                            .onSubmit{
                                if !(searchText.isEmpty) {
                                    configManager.checkConnection()
                                    store.cityName = self.searchText
                                    store.getWeather(success: { weatherData in
                                        let weather = store.weatherData
                                        navigateToWeatherView = true
                                    }, failure: { error in
                                        
                                        print(error)
                                    })
                                    self.isFetchingWeather = store.isFetchingWeather
                                    searchText = ""
//                                    navigateToWeatherView = true
                                }
                                
                                else if searchText.isEmpty {
                                    configManager.checkConnection()
                                    LocalStore.shared.getWeatherData()
                                    self.isFetchingWeather = LocalStore.shared.isFetchingWeather
                                    
                                }
                            }
                        
                        
                        
                    }
                    if DATAMODEL.count > 0 {
                        List{
                            ForEach($DATAMODEL, id: \.city?.id){ $model in
                                HStack{
                                    WeatherCard(model: $model , UnitSelected: store.selectedUnit)
                                    Spacer()
                                }
                               
                                
                                
                            }
                            
                            
                            
                            .onDelete { indexSet in
                                for index in indexSet {
                                    let cityToDelete = DATAMODEL[index].city?.name
                                    if let cityToDelete = cityToDelete {
                                        if let cityObjectToDelete = favWeathers.first(where: { $0.city == cityToDelete }) {
                                            do {
                                                try! realm.write {
                                                    let objectsToDelete = realm.objects(FavWeather.self).filter("city == %@", cityToDelete)
                                                    realm.delete(objectsToDelete)
                                                }
                                                getData()
                                            } catch {
                                                print("Error deleting object: \(error)")
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                            .listRowBackground(
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [Color.color, Color.gray]
                                    ),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                        .scrollContentBackground(.hidden)
                        .listRowSpacing(4.0)
                        
                    }
                    if store.isFetchingWeather {
                        Spacer()
                        ProgressView()
                            .tint(.white)
                    }
                    else if navigateToWeatherView {
                        
                        if let weather = store.weatherData {
                            NavigationLink("",destination: WeatherView(modelData: weather , selectedUnits: store.selectedUnit), isActive: $navigateToWeatherView)
                                .hidden()
                            
                            
                        }
                    }
                    Spacer()
                    
                    
                    
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear(perform: {
                    getData()
                })
            
            
            
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [Color.gray, Color.black]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    ).ignoresSafeArea()
                )
            
                .navigationTitle("Weather")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            //                            Button("Edit List", systemImage: isEditing ? "pencil.circle.fill" : "pencil") {
                            //                                isEditing.toggle() // Toggle the editing mode
                            //                            }
                            
                            
                            Button {
                                store.selectedUnit = .imperial
                                Selection = .imperial
                                configManager.checkConnection()
                                store.getWeather(success: { weatherData in
                                    // Handle successful response with weatherData
                                }, failure: { error in
                                    print(error)
                                })
                                self.isFetchingWeather = store.isFetchingWeather
                                getData()
                                
                            } label: {
                                HStack {
                                    Text("Fahrenheit")
                                    if store.selectedUnit.rawValue == "imperial"{
                                        
                                        Image(systemName: "checkmark.circle")
                                    }
                                }
                            }
                            Button {
                                store.selectedUnit = .metric
                                Selection = .metric
                                configManager.checkConnection()
                                store.getWeather(success: { weatherData in
                                    // Handle successful response with weatherData
                                }, failure: { error in
                                    print(error)
                                })
                                self.isFetchingWeather = store.isFetchingWeather
                                getData()
                            } label: {
                                HStack {
                                    Text("Celcius")
                                    if store.selectedUnit.rawValue == "metric"{
                                        Image(systemName: "checkmark.circle")
                                    }
                                    
                                }
                            }
                            
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                                .foregroundColor(Color.white)
                        }
                    }
                }
            
                .navigationBarTitle("Weather", displayMode: .large)
            
            
            
        }
    }
    private func getData() {
        DATAMODEL = []
        for fav in favWeathers {
            let cityName = fav.city
            store.cityName = cityName
            store.selectedUnit = Selection
            store.getWeather(success: { weatherData in
                let modelData =  weatherData
                DATAMODEL.append(modelData)
                print("Model Data Added: \(modelData)")
            },
                             failure: { error in
                print("Failed to fetch weather data for city: \(cityName) - Error: \(error)")
            })
        }
        print("DATAMODEL: \(DATAMODEL.count)")
    }
    
}



struct WeatherCard: View {
    @Binding var model : WeatherModel
    @State  var UnitSelected: Units?
    @State private var navigateToWeatherView = false
    
    
    var body: some View {
        HStack {
            HStack{
                VStack(alignment: .leading) {
                    Text(model.city?.name ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                    let currentTime = GetTime()
                    Text(currentTime)
                        .font(.footnote)
                    Spacer()
                    Text(model.list?.first?.weather?.first?.description ?? "")
                        .font(.caption)
                    
                }
                Spacer()
                ZStack {
                    NavigationLink(destination: WeatherView(modelData: model, selectedUnits: UnitSelected), isActive: $navigateToWeatherView) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0) // Set the frame size to zero
                    .background(Color.clear) // Make it effectively invisible
                    .hidden()
                }
                VStack(alignment: .trailing) {
                    Text("\(Int(Double(model.list?.first?.main?.temp ?? "0") ?? 0))\(UnitSelected == .metric ? "°C" : "°F")")
                        .font(.largeTitle)
                    Spacer()
                    Text("H: \(Int(Double(model.list?.first?.main?.temp_max ?? "0") ?? 0))\(UnitSelected == .metric ? "°C" : "°F")  L: \(Int(Double(model.list?.first?.main?.temp_min ?? "0") ?? 0))\(UnitSelected == .metric ? "°C" : "°F")")
                        .font(.footnote)
                    
                }
                
                
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        navigateToWeatherView = true
                    }
               
            }
            .padding()
        }
        
        
        
       
        .cornerRadius(16)
        .frame(height: 80)
        .foregroundColor(.white)
       
//        .background(
//            LinearGradient(
//                gradient: Gradient(
//                    colors: [Color.color, Color.gray]
//                ),
//                startPoint: .top,
//                endPoint: .bottom
//            ).ignoresSafeArea()
//        )
        
    }
    
    
    
    func GetTime() -> String {
        let currentDate = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let currentTimeString = timeFormatter.string(from: currentDate)
        
        return currentTimeString
    }
}



//
//for city in favWeathers{
//    if city.city == cityToDelete{
//        $favWeathers.remove(city)
//
//
//    }







#Preview {
    ContentView()
}

