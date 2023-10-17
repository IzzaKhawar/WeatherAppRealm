//
//  WeatherAppRealmApp.swift
//  WeatherAppRealm
//
//  Created by apple on 10/11/23.
//

import SwiftUI
import SwiftData

@main
struct WeatherAppRealmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            
            ContentView()
        }
    }
}
