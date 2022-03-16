//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Anushree on 08/03/22.
//

import Foundation

class WeatherViewModel {
    
    var places: [WeatherDataModel] = [WeatherDataModel]()
    
    func fetchWeatherFor(lat: Double, long: Double, completionHandler: @escaping (_ place: WeatherDataModel) -> Void) {
        
        let networkManager = NetworkService()
        
        let url = URL.fetchURLUsingLatitudeAndLongitude(lat: lat, long: long)
        
        networkManager.fetchWeatherData(url: url, completionHandler: {
            
            (json: Any)-> Void
            in
            
            var nameData: String = ""
            var descriptionData: String = ""
            var iconData : String = ""
            
            let jsonData = json as? [String: AnyObject]
            nameData = jsonData?["name"] as? String ?? "no city"
            
            let descriptionAndIcon = jsonData?["weather"] as? [[String: Any]] ?? [["error": 0]]
            
            for item in descriptionAndIcon {
                descriptionData = item["description"] as? String ?? "Error fetching description"
                iconData = item["icon"] as? String ?? "Error fetching icon"
            }
            
            let temparatureData = jsonData?["main"] as? [String: Any] ?? ["error": 0]
            let tempData = temparatureData["temp"]
            let minTempData = temparatureData["temp_min"]
            let maxTempData = temparatureData["temp_max"]
            let humidityData = temparatureData["humidity"]
            
            let place = WeatherDataModel(placeName: nameData, temparature: tempData as! Double, minTemparature: minTempData as! Double, maxTemparature: maxTempData as! Double, humidity: humidityData as! Double, description: descriptionData, icon: iconData)
            
            completionHandler(place)
        })
    }
    
    func fetchWeatherForPlace(placeName: String, completionHandler: @escaping (_ place: WeatherDataModel) -> Void) {
        
        let networkManager = NetworkService()
        
        let url = URL.fetchURLUsingPlaceName(searchedCity: placeName)
        
        networkManager.fetchWeatherData(url: url, completionHandler: {
            
            (json: Any)-> Void
            in
            
            var nameData: String = ""
            var descriptionData: String = ""
            var iconData : String = ""
            
            let jsonData = json as? [String: AnyObject]
            nameData = jsonData?["name"] as? String ?? "no city"
            
            let descriptionAndIcon = jsonData?["weather"] as? [[String: Any]] ?? [["error": 0]]
            
            for item in descriptionAndIcon {
                descriptionData = item["description"] as? String ?? "Error fetching description"
                iconData = item["icon"] as? String ?? "Error fetching icon"
            }
            
            let temparatureData = jsonData?["main"] as? [String: Any] ?? ["error": 0]
            let tempData = temparatureData["temp"]
            let minTempData = temparatureData["temp_min"]
            let maxTempData = temparatureData["temp_max"]
            let humidityData = temparatureData["humidity"]
            
            let place = WeatherDataModel(placeName: nameData, temparature: tempData as! Double, minTemparature: minTempData as! Double, maxTemparature: maxTempData as! Double, humidity: humidityData as! Double, description: descriptionData, icon: iconData)
            
            completionHandler(place)
        })
    }
}

extension WeatherViewModel {
    
    func addPlace(place: WeatherDataModel) {
        
        if places.contains(where: {$0.placeName == place.placeName }) {
            
            if let index = places.firstIndex(where: { $0.placeName == place.placeName }) {
                places.remove(at: index)
                places.insert(place, at: 0)
            }
        } else {
            places.insert(place, at: 0)
        }
    }
    
    func toggleFavourites(place: String)-> Bool {
        
        var index = 0
        var favouriteCityIndex = 0
        
        for city in places {
            if city.placeName == place {
                favouriteCityIndex = index
            }
            index += 1
        }
        places[favouriteCityIndex].isFavourite.toggle()
        return places[favouriteCityIndex].isFavourite
    }
    
    func getRecentSearches() -> PlaceListViewModel {
        
        let viewModel = PlaceListViewModel(places: places)
        viewModel.delegate = self
        viewModel.emptyDelegate = self
        
        return viewModel
    }
    
    func getFavourites() -> PlaceListViewModel {
        
        let favouritePlaces = places.filter({$0.isFavourite == true})
        
        let viewModel = PlaceListViewModel(places: favouritePlaces)
         viewModel.delegate = self
        viewModel.emptyDelegate = self
        
        return viewModel
    }
}

extension WeatherViewModel: PlaceListProtocol, EmptyListProtocol {
    
    func clearPlaces(viewModel: Bool) {
        
        if viewModel == true {
            
            let favouritePlaces = places.filter({$0.isFavourite == true})
            places = favouritePlaces
            
        } else {
            
            let favouritePlaces = places.filter({$0.isFavourite == true})
            
            for city in favouritePlaces {
                city.isFavourite = false
                if let i = places.firstIndex(where: { $0.placeName == city.placeName }) {
                    places[i] = city
                }
            }
        }
    }
    
    func removePlaceAt(index: Int) {
        places.remove(at: index)
    }
}



