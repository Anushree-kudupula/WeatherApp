//
//  ViewController.swift
//  WeatherApp
//
//  Created by Anushree on 22/02/22.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    let viewModel = WeatherViewModel()
    var locationManager = CLLocationManager()
    
    var latVal = 0.0
    var longVal = 0.0
    var searchedCityName = ""
    var celsiusTemparature: Int? = 0
    var celsiusMinTemparature: Int? = 0
    var celsiusMaxTemparature: Int? = 0
    var searchedCity = ""
    
    let labels = ["Min - Max", "Precipitation", "Humidity"]
    let dataLogos = [#imageLiteral(resourceName: "temp_icon.png"), #imageLiteral(resourceName: "icon_precipitation_info.png"), #imageLiteral(resourceName: "icon_humidity_info.png") ]
    var temparatureData = ["21° - 24°", "0%", "30%"] {
        
        didSet {
            tempDataCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var forecastedSymbol: UIImageView!
    @IBOutlet weak var forecastedTemparature: UILabel!
    @IBOutlet weak var forecastedDescription: UILabel!
    @IBOutlet weak var celsiusAndFahrenhite: UISegmentedControl!
    @IBOutlet weak var logoBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tempDataCollectionView: UICollectionView!
    @IBOutlet weak var serachCityView: UIView!
    @IBOutlet weak var searchCityBar: UISearchBar!
    @IBOutlet weak var favourite: UIButton!
    @IBOutlet weak var favouriteSymbol: UIButton!
    @IBOutlet weak var sideMenu: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setDateAndTime()
        setDefaultTemparatureScale()
        getCurrentLocation()
        
        searchCityBar.delegate = self
        tempDataCollectionView.delegate = self
        tempDataCollectionView.dataSource = self
        tempDataCollectionView.alpha = 0.6
        tempDataCollectionView.backgroundColor = .clear
    }
    
    func setDateAndTime() {
        
        let day = Date().string(format: "E")
        let date = Date().string(format: "dd")
        let month = Date().string(format: "MMM")
        let yearAndTime = Date().string(format: "yyyy     hh:mm a")
        self.dateAndTime.text = (day.uppercased() + "," + "  " + date + " " + month.uppercased() + " " + yearAndTime)
    }
    
    func setDefaultTemparatureScale() {
        
        celsiusAndFahrenhite.layer.borderWidth = 1.0
        celsiusAndFahrenhite.layer.borderColor = UIColor.white.cgColor
        celsiusAndFahrenhite.selectedSegmentIndex = 0
        celsiusAndFahrenhite.selectedSegmentTintColor = UIColor.white
        celsiusAndFahrenhite.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
    }
    
    func setDefaultFavouritesImageLabel() {
        
        favourite.setTitle("Add to favourites", for: .normal)
        favouriteSymbol.setImage( #imageLiteral(resourceName: "favourite.png") , for: .normal)
    }
    
    func getCurrentLocation() {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = tempDataCollectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! TemparatureCollectionViewCell
        cell.infoLogo.image = dataLogos[indexPath.item]
        cell.infoLabel.text = labels[indexPath.item]
        cell.temparature.text = self.temparatureData[indexPath.item]
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if let city = searchBar.text {
            searchedCity = city
            self.searchCityBar.text = ""
            serachCityView.isHidden = true
            
            setDefaultFavouritesImageLabel()
            viewModel.fetchWeatherForPlace(placeName: searchedCity, completionHandler:  {
                
                (place: WeatherDataModel) -> Void
                in
                DispatchQueue.main.async {
                    
                    self.cityName.text = place.placeName
                    self.forecastedDescription.text = place.description
                    self.forecastedSymbol.image = UIImage(named: place.icon)
                    self.celsiusTemparature = Int(place.temparature)
                    self.celsiusMinTemparature = Int(place.minTemparature)
                    self.celsiusMaxTemparature = Int(place.maxTemparature)
                    self.forecastedTemparature.text = "\(Int(place.temparature))"
                    self.temparatureData[0] = "\(Int(place.minTemparature))" + "°" + " - " + "\(Int(place.maxTemparature))" + "°"
                    self.temparatureData[2] = "\(Int(place.humidity))" + "%"
    
                    self.viewModel.addPlace(place: place)
                }
            })
        }
    }
    
    func setFavouriteImageAndLabel(value: Bool) {
        
        if value == true {
            favouriteSymbol.setImage(#imageLiteral(resourceName: "icon_favourite_active.png"), for: .normal)
            favourite.setTitle("Added to favourite", for: .normal)
        } else {
            favouriteSymbol.setImage(#imageLiteral(resourceName: "favourite.png"), for: .normal)
            favourite.setTitle("Add to favourite", for: .normal)
        }
    }
    
    @IBAction func addToFavouriteTapped(_ sender: Any) {
        let result = viewModel.toggleFavourites(place: cityName.text!)
        setFavouriteImageAndLabel(value: result)
        print(result)
    }
    
    @IBAction func favouriteSymbolTapped(_ sender: Any) {
        let result = viewModel.toggleFavourites(place: cityName.text!)
        setFavouriteImageAndLabel(value: result)
        print(result)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        sideMenu.isHidden = false
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        sideMenu.isHidden = true
    }
    
    @IBAction func celsiusAndFahrenhiteTapped(_ sender: Any) {
        
        switch celsiusAndFahrenhite.selectedSegmentIndex {
        case 0:
            if let temp = celsiusTemparature {
                forecastedTemparature.text = "\(temp)"
            }
            if let min = celsiusMinTemparature, let max = celsiusMaxTemparature {
                temparatureData[0] = "\(min)" + "°" + " - " + "\(max)" + "°"
            }
            
        case 1:
            if let temp = celsiusTemparature {
                forecastedTemparature.text = "\(temp * 9 / 5 + 32)"
            }
            if let min = celsiusMinTemparature, let max = celsiusMaxTemparature {
                temparatureData[0] = "\(min * 9 / 5 + 32)" + "°" + " - " + "\(max * 9 / 5 + 32)" + "°"
            }
            
        default:
            break
        }
    }
    
    @IBAction func searchCityTapped(_ sender: UIBarButtonItem) {
        serachCityView.isHidden = false
    }
    
    @IBAction func recentSearchesTapped(_ sender: Any) {
        displayRecentSearchesTableView()
        sideMenu.isHidden = true
    }
    
    @IBAction func favouritesListTapped(_ sender: Any) {
        displayFavouritesTableView()
        sideMenu.isHidden = true
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latVal = locValue.latitude
        longVal = locValue.longitude
        viewModel.fetchWeatherFor(lat: latVal, long: longVal, completionHandler: {
            
            (place: WeatherDataModel) -> Void
            in
            DispatchQueue.main.async {
                
                self.cityName.text = place.placeName
                self.forecastedDescription.text = place.description
                self.forecastedSymbol.image = UIImage(named: place.icon)
                self.celsiusTemparature = Int(place.temparature)
                self.celsiusMinTemparature = Int(place.minTemparature)
                self.celsiusMaxTemparature = Int(place.maxTemparature)
                self.forecastedTemparature.text = "\(Int(place.temparature))"
                self.forecastedTemparature.text = "\(Int(place.temparature))"
                self.temparatureData[0] = "\(Int(place.minTemparature))" + "°" + " - " + "\(Int(place.maxTemparature))" + "°"
                self.temparatureData[2] = "\(Int(place.humidity))" + "%"
                
                self.viewModel.addPlace(place: place)
            }
        })
    }
}

extension ViewController {
    
    func displayRecentSearchesTableView() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlacesViewController") as? PlacesViewController
        vc?.isRecentSeague = true
        let recentSearchVM = viewModel.getRecentSearches()
        vc?.viewModel = recentSearchVM
        vc?.navigationTitle.title = "Recent Searches"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func displayFavouritesTableView() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlacesViewController") as? PlacesViewController
        let recentSearchVM = viewModel.getFavourites()
        vc?.viewModel = recentSearchVM
        vc?.navigationTitle.title = "Favourites"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}



