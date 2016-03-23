//
//  TripTableViewCell.swift
//  TaskScheduler
//
//  Created by Ben Oztalay on 9/18/15.
//  Copyright © 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tripDest: UILabel!
    
    @IBOutlet weak var fromDateTrip: UILabel!
    
    @IBOutlet weak var toDateTrip: UILabel!
    
    @IBOutlet weak var delButton: UIButton!
    
    
    
    private static var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.formattingContext = .MiddleOfSentence
        formatter.dateStyle = .FullStyle
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTrip(trip: Trip) {
        self.tripDest.text = trip.destination
        self.fromDateTrip.text = "From " + TripTableViewCell.dateFormatter.stringFromDate(trip.arrDate!)
        self.toDateTrip.text = "To " + TripTableViewCell.dateFormatter.stringFromDate(trip.depDate!)
        
        
    }
    func getDestination (trip : Trip) -> String {
        let dest = trip.destination
        return dest!
    }
    
    func getArrDate (trip : Trip) -> NSDate {
        let arrDate = trip.arrDate
        return arrDate!
    }
    
    
    func getDepDate (trip : Trip) -> NSDate {
        let depDate = trip.depDate
        return depDate!
    }
    
    func getFlag (trip : Trip) -> NSString {
        let flag = trip.flag
        return flag!
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    
}
