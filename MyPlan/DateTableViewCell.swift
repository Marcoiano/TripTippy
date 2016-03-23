//
//  PlanTableViewCell.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 23/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayDate: UILabel!
    
    @IBOutlet weak var weekDay: UILabel!
    
    @IBOutlet weak var forecastImage: UIImageView!
    
    @IBOutlet weak var tempMax: UILabel!
    
    @IBOutlet weak var tempMin: UILabel!
    
    @IBOutlet weak var trat: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDate(date: Date) {
        self.weekDay.text = date.weekDay
        self.dayDate.text = date.dayDate
        
        
        
    }
    
    func getWeekD (date : Date) -> String {
        let weekD = date.weekDay
        return weekD!
    }
    
    func getDayD (date : Date) -> String {
        let dayD = date.dayDate
        return dayD!
    }
    
    func getFlag (date : Date) -> NSString {
        let flag = date.flag
        return flag!
    }
    
    
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

