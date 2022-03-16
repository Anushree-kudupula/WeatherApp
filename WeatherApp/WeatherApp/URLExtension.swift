//
//  URLExtension.swift
//  WeatherApp
//
//  Created by Anushree on 08/03/22.
//

import Foundation

extension URL {
    
    static let APIKey = "52ba266b5d15d637fed72551de63fea9"
    
    static func fetchURLUsingLatitudeAndLongitude(lat: Double, long: Double)-> URL {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(APIKey)&units=metric") else {
            
            fatalError("URL fetch error!!!")
        }
        return url
    }
    
    static func fetchURLUsingPlaceName(searchedCity: String)-> URL {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?&appid=\(APIKey)&q=\(searchedCity)&units=metric") else {
            
            fatalError("URL fetch error for your searched city!!!")
        }
        return url
    }
}
