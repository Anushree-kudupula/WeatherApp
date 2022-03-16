//
//  PlacesViewController.swift
//  WeatherApp
//
//  Created by Anushree on 11/03/22.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: PlaceListViewModel?
    
    @IBOutlet weak var tableViewLabel: UILabel!
    @IBOutlet weak var placeTableView: UITableView!
    @IBOutlet weak var tableViewButtonTitle: UIButton!
    @IBOutlet weak var navigationTitle: UIBarButtonItem!
    var isRecentSeague: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeTableView.delegate = self
        placeTableView.dataSource = self
        setUpUI()
        displayEmpty()
    }
    
    func displayEmpty() {
        
        if viewModel?.count() == 0 {
            placeTableView.isHidden = true
            tableViewLabel.isHidden = true
            tableViewButtonTitle.isHidden = true
            
            let emptyPlaceImage = UIImage(named: "icon_nothing")
            let emptyImageView:UIImageView = UIImageView()
            emptyImageView.contentMode = UIView.ContentMode.scaleAspectFit
            emptyImageView.frame.size.width = 200
            emptyImageView.frame.size.height = 200
            emptyImageView.center = self.view.center
            emptyImageView.image = emptyPlaceImage
            view.addSubview(emptyImageView)
            
            let label = UILabel(frame: CGRect(x: emptyImageView.frame.origin.x, y: emptyImageView.frame.origin.y + emptyImageView.frame.size.height, width: emptyImageView.frame.size.width, height: 45))
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            if isRecentSeague {
                label.text = "No Recent Searches"
            } else {
                label.text = "No Favourites"
            }
            label.textColor = .white
            view.addSubview(label)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let viewModel = viewModel {
            return viewModel.count()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EachCell", for: indexPath) as? PlaceTableViewCell {
            
            if let viewModel = viewModel {
                if let place = viewModel.getPlaceAtIndex(index: indexPath.row) {
                    
                    cell.cityName.text = place.location
                    cell.weatherDescription.text = place.description
                    cell.temparature.text = "\(Int(place.temparature))"
                    cell.weatherIcon.image = UIImage(named: "\(place.icon)")
                    
                    cell.buttonAction = { currentCell in
                        let selectedIndexPath = indexPath.row
                        print(selectedIndexPath)
                        viewModel.favouriting(index: selectedIndexPath)
                    }
                    
                    if place.isFavourite == true {
                        cell.favouriteSymbol.setImage(#imageLiteral(resourceName: "icon_favourite_active.png"), for: .normal)
                    }
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel?.removePlaceAt(index: indexPath.row)
            placeTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func setUpUI() {
        
        if isRecentSeague == true {
            
            tableViewLabel.text = "You recently searched for "
            tableViewButtonTitle.setTitle("Clear All", for: .normal)
           
        } else {
            
            if let viewModel = viewModel {
                tableViewLabel.text = "\(viewModel.count())" + " City added as favourite"
            }
            tableViewButtonTitle.setTitle("Remove All", for: .normal)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func clearTapped(_ sender: Any) {
        
        var alertMessage = ""
        
        if isRecentSeague == false {
            
            alertMessage = "Are you sure want to remove all the favourites?"
            
        } else {
            
            alertMessage = "Are you sure want to clear all the recent Searches?"
        }
        let alert = UIAlertController(title: "Clear All", message: alertMessage , preferredStyle: .alert)
        
        let optionNo = UIAlertAction(title: "No", style: .cancel) { (selection) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let optionYes = UIAlertAction(title: "Yes", style: .default) { (selection) in
            alert.dismiss(animated: true, completion: nil)
            self.viewModel?.clearPlaces(viewModel: self.isRecentSeague)
            self.displayEmpty()
        }
        
        present(alert, animated: true, completion: nil)
        alert.addAction(optionNo)
        alert.addAction(optionYes)
    }
}
