//
//  MustStarred+CoreDataProperties.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 06/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation

extension Favorite {
    @NSManaged var activity: String?
    @NSManaged var flag : String?
    @NSManaged var favFlag : String?
    @NSManaged var type : String?
    @NSManaged var trip: Trip?
    
}
