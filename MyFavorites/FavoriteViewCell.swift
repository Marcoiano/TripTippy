//
//  FavoriteViewCell.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 06/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//
import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activity: UILabel!
    
    @IBOutlet weak var favTypeImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setFav(fav: Favorite) {
        self.activity.text = fav.activity
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}


