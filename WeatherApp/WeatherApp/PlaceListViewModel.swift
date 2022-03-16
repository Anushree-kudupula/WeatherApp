//
//  PlaceListViewModel.swift
//  WeatherApp
//
//  Created by Anushree on 12/03/22.
//

import Foundation
import UIKit

struct PlaceRepresentation {
    
    let location: String
    let temparature: Double
    let description: String
    let icon: String
    let isFavourite: Bool
    
    init(location: String, temparature: Double, description: String, icon: String, isFavourite: Bool) {
        
        self.location = location
        self.temparature = temparature
        self.description = description
        self.icon = icon
        self.isFavourite = isFavourite
    }
}

protocol PlaceListProtocol: AnyObject {

    func removePlaceAt(index: Int)
}

protocol EmptyListProtocol: AnyObject {
    
    func clearPlaces(viewModel: Bool)
}

class PlaceListViewModel {
    
    var places: [WeatherDataModel] = [WeatherDataModel]()
    
    weak var delegate: PlaceListProtocol?
    weak var emptyDelegate: EmptyListProtocol?
    //weak var favDelegate: FavouriteProtocol?
    
    init(places: [WeatherDataModel]) {
        self.places = places
    }
    
    func count() -> Int {
        return places.count
    }
    
    func getPlaceAtIndex(index: Int) -> PlaceRepresentation? {

        if(index > -1 && index < places.count) {

            let place = places[index]

            let placeRepresentation = PlaceRepresentation(location: place.placeName, temparature: place.temparature, description: place.description, icon: place.icon, isFavourite: place.isFavourite)

            return placeRepresentation
        }

        return nil
    }
    
    func removePlaceAt(index: Int) {
        
        if(index > -1 && index < places.count) {
            places.remove(at: index)
        }
        delegate?.removePlaceAt(index: index)
    }
    
    func clearPlaces(viewModel: Bool) {
        
        places.removeAll()
        emptyDelegate?.clearPlaces(viewModel: viewModel)
    }
    
    func favouriting(index: Int) {
        
        if(index > -1 && index < places.count) {
            places[index].isFavourite.toggle()
        }
    }
}
