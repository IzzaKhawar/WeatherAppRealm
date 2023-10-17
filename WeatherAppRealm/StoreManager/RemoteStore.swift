//
//  RemoteStore.swift
//  WeatherApp
//
//  Created by apple on 10/3/23.
//

import Foundation
import Alamofire
import SwiftUI

class RemoteStore: ObservableObject{
    
    static let shared = RemoteStore()
    
    internal init() { }
    
    func get(endPoint: String, parameters: Parameters?, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(
            Constants.shared.baseURL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: nil
        ).validate(statusCode: 200 ..< 299)
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWeatherByCityName(params: Parameters, success: @escaping (WeatherModel) -> Void, failure: @escaping (Error) -> Void) {
        RemoteStore.shared.get( endPoint: Constants.shared.baseURL, parameters: params) { response in
            switch response {
                case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(WeatherModel.self, from: data)
                    success(weather)
                } catch {
                    failure(error)
                }
                   
                        
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    
}
