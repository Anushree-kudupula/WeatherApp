//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Anushree on 25/02/22.
//

import Foundation

extension Date {
    
    func string(format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

