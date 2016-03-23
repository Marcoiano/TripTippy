//
//  EventsViewCell.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 03/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Parse
import UIKit

class EventsViewCell : PFTableViewCell {
    
    
    @IBOutlet weak var eventName: UILabel!
    
    
    @IBOutlet weak var startH: UILabel!
    
    
    @IBOutlet weak var endH: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    
}

