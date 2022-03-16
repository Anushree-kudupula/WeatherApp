//
//  PlaceTableViewCell.swift
//  WeatherApp
//
//  Created by Anushree on 11/03/22.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temparature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var favouriteSymbol: UIButton!
    
    var buttonAction: ((UITableViewCell) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
        buttonAction?(self)
    }
    
}
