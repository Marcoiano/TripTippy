//
//  CreateTripViewController.swift
//  MyTrip
//
//  Created by Marco Tabacchino on 25/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit
import CoreData

class CreateTripViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var trip: Trip?
    var isChangingTrip: Bool = false
    var receivedString : String! = ""
    var valueToPass: String!
    let userCalendar = NSCalendar.currentCalendar()
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var arrivalDatePic: UIDatePicker!
    
    @IBOutlet weak var departureDatePic: UIDatePicker!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrivalDatePic.datePickerMode = UIDatePickerMode.Date
        departureDatePic.datePickerMode = UIDatePickerMode.Date
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
    
    // Diference between two NSDate -> Int +1
    func timeBetween(startDate: NSDate, endDate: NSDate) -> Int
    {
        let cal = NSCalendar.currentCalendar()
        let components = cal.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        return components.day + 1
    }
    
    //random
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        let arrivalDate = arrivalDatePic.date
        let departureDate = departureDatePic.date
        if departureDate.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            let alert = UIAlertController(title: "Past Date", message: "Hey! This date is in the past!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Sorry", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        createTrip(receivedString, arrDate: arrivalDate, depDate: departureDate)
        
        //Stampa tutti i giorni tra le due date
        var date = arrivalDatePic.date // first date
        let endDate = departureDatePic.date // last date
        
        // Formatter for printing the date, adjust it according to your needs:
        let fmtW = NSDateFormatter()
        let fmtD = NSDateFormatter()
        let fmtM = NSDateFormatter()
        let fmtY = NSDateFormatter()
        
        fmtW.dateFormat = "EE"
        fmtD.dateFormat = "dd"
        fmtM.dateFormat = "MM"
        fmtY.dateFormat = "YY"
        
        let calendar = NSCalendar.currentCalendar()
        
        
        let endDateFinal = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: endDate, options: NSCalendarOptions(rawValue: 0))
        
        
        while date.compare(endDateFinal!) != .OrderedDescending {
            let weekD = (fmtW.stringFromDate(date))
            let dDate = (fmtD.stringFromDate(date))
            let mDate = (fmtM.stringFromDate(date))
            let yDate = (fmtY.stringFromDate(date))
            
            
            addDataInTrip(receivedString, arrDate: arrivalDatePic.date, depDate: departureDatePic.date, weekDay: weekD, dayDate: dDate, monthDate: mDate, yearDate: yDate)
            
            date = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: [])!
        }
        
        
        //Codice parse
        let trip = PFObject(className:"Trip")
        trip ["StartDate"] = arrivalDatePic.date
        trip ["EndDate"] = departureDatePic.date
        trip ["City"] = receivedString
        trip ["createdBy"] = PFUser.currentUser()
        trip.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                
                // There was a problem, check error.description
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    func dismissViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK:- Create trip
    func createTrip(dest : String , arrDate : NSDate, depDate : NSDate) {
        let entityDescripition = NSEntityDescription.entityForName("Trip", inManagedObjectContext: managedObjectContext)
        let trip = Trip(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMddYY"
        trip.destination = dest//da vedere
        trip.arrDate = arrDate
        trip.depDate = depDate
        trip.flag = dest+formatter.stringFromDate(arrDate)
        
        
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    
    func salvaContext() {
        do {
            try self.managedObjectContext.save()
            print("ok")
            
            
        } catch {
            print (error)
        }
    }
    
    func addDataInTrip(dest : String , arrDate : NSDate, depDate : NSDate,  weekDay : String, dayDate : String, monthDate : String, yearDate : String) {
        let trip = cercaTrip(dest,arrDate: arrDate,depDate: depDate)
        let entityDescripition = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedObjectContext)
        var nuovaData = Date(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        
        
        func salvaDataInTrip() {
            let modelTrip = trip
            nuovaData.trip = modelTrip
            nuovaData.weekDay = weekDay
            nuovaData.dayDate = dayDate
            nuovaData.flag = receivedString+monthDate+dayDate+yearDate
            //randomStringWithLength(5) as String
            modelTrip!.addDate(nuovaData)
            
            salvaContext()
        }
        salvaDataInTrip()
        
    }
    
    
    func cercaTrip(dest :String, arrDate : NSDate, depDate : NSDate) -> Trip? {
        var trip : Trip?
        //var gestoreErrore = NSErrorPointer() // da utilizzare se vuoi gestire gli errori
        let request = NSFetchRequest(entityName: "Trip")
        request.predicate = NSPredicate (format: "destination = %@ AND arrDate = %@",argumentArray : [dest,arrDate])
        request.returnsObjectsAsFaults = false
        
        let result :NSArray = try! managedObjectContext.executeFetchRequest(request)
        trip = result[0] as? Trip
        
        return trip!
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        destinationLabel.text = receivedString
        
    }
    
}
