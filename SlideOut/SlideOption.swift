//
//  SlideOption.swift
//  Model
//
//  Created by Marco Tabacchino on 01/11/2015.
//  Copyright (c) 2015 Marco Tabacchino. All rights reserved.
//

import UIKit


class SlideOption {
    
    let title: String
    let image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    class func allOptions() -> Array<SlideOption> {
        return [ SlideOption(title: "My Profile", image: UIImage(named: "user"))]
        
    }
    
}