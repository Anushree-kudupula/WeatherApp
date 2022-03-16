//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Anushree on 08/03/22.
//

import Foundation

class NetworkService {
    
    func fetchWeatherData(url: URL, completionHandler: @escaping (_ json: Any) -> Void) {
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?)
            in
            
            if let error = error {
                
                print(error)
                return
            }
            
            if let response = response {
                print("Successfully getting the response")
            }
            
            if let data = data {
                
                do {
                    
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                    completionHandler(jsonResponse)
                    
                } catch {
                    
                    print(error)
                }
            }
        }
        
        task.resume()
    }
}
