//
//  Trip+CoreDataProperties.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 29/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import CoreData

extension Trip {
    @NSManaged var destination: String?
    @NSManaged var arrDate: NSDate?
    @NSManaged var depDate: NSDate?
    @NSManaged var flag : String?
    @NSManaged var dates : NSSet?
    @NSManaged var favs : NSSet?
}

extension Trip {
    func addDate(value: Date) {
        let items = self.mutableSetValueForKey("dates");
        items.addObject(value)
    }
    
    func removeDate(value: Date) {
        let items = self.mutableSetValueForKey("dates");
        items.removeObject(value)
    }
    
    func addFav(value: Favorite) {
        let items = self.mutableSetValueForKey("favs");
        items.addObject(value)
    }
    
    func removeFav(value: Favorite) {
        let items = self.mutableSetValueForKey("favs");
        items.removeObject(value)
    }
    
}

