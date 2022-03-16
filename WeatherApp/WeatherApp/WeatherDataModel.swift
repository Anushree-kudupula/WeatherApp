//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Anushree on 09/03/22.
//

import Foundation

class WeatherDataModel {
    
    var placeName: String
    var temparature: Double
    var minTemparature: Double
    var maxTemparature: Double
    var humidity: Double
    var description: String
    var icon: String
    
    var isFavourite: Bool = false
    
    init(placeName: String, temparature: Double, minTemparature: Double, maxTemparature: Double, humidity: Double, description: String, icon: String) {
        
        self.placeName = placeName
        self.temparature = temparature
        self.minTemparature = minTemparature
        self.maxTemparature = maxTemparature
        self.humidity = humidity
        self.description = description
        self.icon = icon
        
    }
}
