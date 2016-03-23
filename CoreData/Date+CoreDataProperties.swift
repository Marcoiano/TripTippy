//
//  Date+CoreDataProperties.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 29/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import CoreData

extension Date {
    @NSManaged var weekDay: String?
    @NSManaged var dayDate: String?
    @NSManaged var monthDate : String?
    @NSManaged var yearDate : String?
    @NSManaged var flag: String?
    @NSManaged var trip: Trip?
    @NSManaged var plans : NSSet?
    
}

extension Date {
    func addPlan(value: Plan) {
        let items = self.mutableSetValueForKey("plans");
        items.addObject(value)
    }
    
    func removeDate(value: Plan) {
        let items = self.mutableSetValueForKey("plans");
        items.removeObject(value)
    }
}

