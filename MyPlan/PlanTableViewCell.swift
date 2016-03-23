//
//  PlanTableViewCell.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 23/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activity: UILabel!
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
    private static var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPlan(plan: Plan) {
        self.activity.text = plan.activity
        self.startDate.text = "From " + PlanTableViewCell.dateFormatter.stringFromDate(plan.startH!)
        self.endDate.text = "To " + PlanTableViewCell.dateFormatter.stringFromDate(plan.endH!)
        
        
    }
    func getActivity(plan : Plan) -> String! {
        let activity = plan.activity
        return activity
    }
    func getStartH(plan : Plan) -> NSDate! {
        let startH = plan.startH
        return startH
    }
    func getEndH (plan : Plan) -> NSDate! {
        let endH = plan.endH
        return endH
        
    }
    func getType (plan : Plan) -> String! {
        let type = plan.type
        return type
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}

