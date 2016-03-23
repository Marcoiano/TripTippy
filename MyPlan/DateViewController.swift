//
//  DateViewController.swift
//  MyPlan
//
//  Created by Marco Tabacchino on 23/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI
import Alamofire

class DateViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var date : Date?
    var trip : Trip?
    var dayWeather : Weather!
    
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    var startDate : NSDate!
    var endDate : NSDate!
    var city : String = ""
    var icons : [String]!
    var tempMaxs : [String]!
    var tempMins : [String]!
    var tripFlag : NSString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDate = appDelegate.startDate
        endDate = appDelegate.endDate
        city = appDelegate.city
        icons = appDelegate.icons
        tempMaxs = appDelegate.tempMaxs
        tempMins = appDelegate.tempMins
        tripFlag = appDelegate.tripFlag
        trip = appDelegate.trip
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: true)
        
        
        
    }
    
    
    
    
    
    // MARK:- Retrieve Tasks
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Date")
        let sortDescriptor = NSSortDescriptor(key: "trip", ascending: true)
        fetchRequest.predicate = NSPredicate(format:"trip = %@", self.trip!)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: AnyObject) {
        let myTripPage = self.storyboard?.instantiateViewControllerWithIdentifier("MyTripViewController") as! MyTripViewController
        
        let myTripPageNav = UINavigationController(rootViewController: myTripPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = myTripPageNav
        myTripPage.startDate = appDelegate.startDate
        myTripPage.endDate = appDelegate.endDate
        myTripPage.city = appDelegate.city
        myTripPage.trip = appDelegate.trip
        myTripPage.cityWeather = appDelegate.cityWeather
        
        
    }
    
    
}

// MARK: - TableView data source
extension DateViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        
        return numberOfRowsInSection!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Date Cell", forIndexPath: indexPath) as! DateTableViewCell
        let date = fetchedResultController.objectAtIndexPath(indexPath) as! Date
        
        cell.setDate(date)
        let currentDate = NSDate()
        let daysDif = timeBetween(NSDate(), endDate: startDate)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMddYY"
        let str = formatter.stringFromDate(currentDate)
        if str == cell.getFlag(date) {
            cell.forecastImage.image = UIImage(named : icons[indexPath.row])
            cell.tempMax.text = tempMaxs[indexPath.row]
            cell.tempMin.text = tempMins[indexPath.row]
            
        }
        else if cell.getFlag(date) != str && daysDif >= 1 {
            let difIndex = daysDif + indexPath.row
            if difIndex <= 4 {
                cell.forecastImage.image = UIImage(named : icons[difIndex])
                cell.tempMax.text = tempMaxs[difIndex]
                cell.tempMin.text = tempMins[difIndex]
            } else if difIndex > 4 {
                cell.forecastImage.image = UIImage(named : "noimage")
                cell.tempMax.text = ""
                cell.trat.text = ""
                cell.tempMin.text = ""
            }
        }
        
        
        
        
        
        return cell
        
    }
}

extension DateViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = DateTableViewCell()
        let date  = fetchedResultController.objectAtIndexPath(indexPath) as! Date
        appDelegate.tripFlag = (cell.getFlag(date) as String)
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    // MARK: - TableView Refresh
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
}




func incrementIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
    var nextIndexPath: NSIndexPath?
    //let nextRow = indexPath.row + 1
    let currentSection = indexPath.section
    
    let nextSection = currentSection + 1
    nextIndexPath = NSIndexPath(forRow: 1, inSection: nextSection)
    
    
    
    return nextIndexPath
}




func timeBetween(startDate: NSDate, endDate: NSDate) -> Int
{
    let cal = NSCalendar.currentCalendar()
    let components = cal.components([.Day], fromDate: startDate, toDate: endDate, options: [])
    return components.day + 1
}


  