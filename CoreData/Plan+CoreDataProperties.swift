//
//  Plan+CoreDataProperties.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 29/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import CoreData

extension Plan {
    
    @NSManaged var activity: String?
    @NSManaged var startH: NSDate?
    @NSManaged var endH: NSDate?
    @NSManaged var flag: String?
    @NSManaged var type: String?
    @NSManaged var date : Date?
    
}
