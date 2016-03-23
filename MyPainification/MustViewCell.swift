//
//  MustViewCell.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 12/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Parse
import UIKit

class MustViewCell : PFTableViewCell {
    
    
    @IBOutlet weak var mustName: UILabel!
    
    @IBOutlet weak var thumb: PFImageView!
    
    @IBOutlet weak var spunta: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func impostaImage(Nome : String) {
        spunta.image = UIImage(named : Nome)
    }
    
    
}
