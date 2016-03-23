//
//  DetailsEventController.swift
//  MyPianification
//
//  Created by Marco Tabacchino on 03/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//


import UIKit
import CoreData
import Parse
import ParseUI
import CoreLocation
import MapKit

class DetailsEventViewController : UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var currentObject : PFObject?
    var date : Date?
    var flag : NSString = ""
    var tripFlag : NSString = ""
    var city : String = ""
    
    
    // Some text fields
    
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    @IBOutlet weak var nameEventDet: UILabel!
    
    @IBOutlet weak var infoEventDet: UILabel!
    
    
    @IBOutlet weak var startHDet: UILabel!
    
    @IBOutlet weak var endHDet: UILabel!
    
    var startH : NSDate!
    var endH : NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unwrap the current object object
        if let object = currentObject {
            nameEventDet.text = object["Name"] as? String
            infoEventDet.text = object["Details"] as? String
            let formatter = NSDateFormatter()
            formatter.dateFormat = "hh : mm"
            let startObj = object["StartH"] as? NSDate
            let endObj = object["EndH"] as? NSDate
            startHDet.text = formatter.stringFromDate(startObj!)
            endHDet.text = formatter.stringFromDate(endObj!)
            address.text = object ["address"] as? String
            
        }
        
        var locationManager = CLLocationManager()
        
        
        
        //MARK: *** let's look for other users ***
        
        var nearArray : [CLLocationCoordinate2D] = []
        
        func showEventLocation() {
            PFQuery(className: city+"Events").whereKey("Name", equalTo: nameEventDet.text!).findObjectsInBackgroundWithBlock ({
                objects, error in
                if let cityMust = objects as? [PFObject] {
                    //                        println("****** here the proximity matches: \(proximityArray)")
                    for key in cityMust {
                        //                            println("here they are \(near)")
                        let position = key["location"] as? PFGeoPoint
                        
                        let theirLat = position?.latitude       //this is an optional
                        let theirLong = position?.longitude     //this is an optional
                        let theirLocation = CLLocationCoordinate2D(latitude: theirLat!, longitude: theirLong!)
                        
                        if cityMust.isEmpty {
                            print("*** ERROR! anyone close by ***")
                        } else
                        {
                            let span = MKCoordinateSpanMake(0.015, 0.015)
                            let region = MKCoordinateRegionMake(theirLocation, span)
                            self.mapView.setRegion(region, animated: true)
                            
                            let theirAnotation = MKPointAnnotation()
                            theirAnotation.coordinate = theirLocation
                            theirAnotation.title = key["Name"] as? String
                            
                            self.mapView.addAnnotation(theirAnotation)
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
            })
        }
        
        showEventLocation()
        
        
        
    }
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @IBAction func addToFav(sender: AnyObject) {
        createFav(nameEventDet.text!, tripFlag: tripFlag as String)
        addFavInTrip(nameEventDet.text!, tripFlag: tripFlag)
        
        let alert = UIAlertController(title: "Event correctly added to your favorites", message: "", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) {
            UIAlertAction in
            self.navigationController!.popViewControllerAnimated(true)
        }
        alert.addAction(okAction)
        
        //favButton.image = UIImage(named: "sifav")
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func createFav(activity : String, tripFlag : String) {
        let entityDescripition = NSEntityDescription.entityForName("Favorite", inManagedObjectContext: managedObjectContext)
        let favorite = Favorite(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        favorite.activity = activity
        favorite.flag = tripFlag
        favorite.favFlag = activity+tripFlag
        favorite.type = "E"
        
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    func addFavInTrip(activity : String , tripFlag : NSString) {
        let trip = cercaTrip(tripFlag)
        let entityDescripition = NSEntityDescription.entityForName("Favorite", inManagedObjectContext: managedObjectContext)
        var nuovoFav = Favorite(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        
        
        func salvaFavInTrip() {
            let modelTrip = trip
            nuovoFav.trip = modelTrip
            nuovoFav.activity = activity
            nuovoFav.favFlag = activity+(tripFlag as String)
            nuovoFav.type = "E"
            modelTrip!.addFav(nuovoFav)
            
            salvaContext()
        }
        salvaFavInTrip()
        
    }
    
    
    func cercaTrip(flag : NSString) -> Trip? {
        var trip : Trip?
        //var gestoreErrore = NSErrorPointer() // da utilizzare se vuoi gestire gli errori
        let request = NSFetchRequest(entityName: "Trip")
        request.predicate = NSPredicate (format: "flag = %@",flag)
        request.returnsObjectsAsFaults = false
        
        let result :NSArray = try! managedObjectContext.executeFetchRequest(request)
        trip = result[0] as? Trip
        
        return trip!
        
    }
    func cercaFav(favFlag : NSString) -> Favorite? {
        var favorite : Favorite?
        //var gestoreErrore = NSErrorPointer() // da utilizzare se vuoi gestire gli errori
        let request = NSFetchRequest(entityName: "Favorite")
        request.predicate = NSPredicate (format: "favFlag = %@",favFlag)
        request.returnsObjectsAsFaults = false
        
        let result :NSArray = try! managedObjectContext.executeFetchRequest(request)
        favorite = result[0] as? Favorite
        
        return favorite!
        
    }
    
    
    
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        //createPlan(nameEventDet.text!, startH : startH, endH : endH, flag : flag as String)
        addPlanInDateMultiplo(nameEventDet.text!, startH: startH, endH: endH, flag: flag)
        
        
        let alert = UIAlertController(title: "Evento aggiunto correttamente", message: "", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) {
            UIAlertAction in
            self.navigationController!.popViewControllerAnimated(true)
        }
        alert.addAction(okAction)
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func createPlan(activity : String , startH : NSDate, endH : NSDate, flag : String) {
        let entityDescripition = NSEntityDescription.entityForName("Plan", inManagedObjectContext: managedObjectContext)
        let plan = Plan(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        plan.activity = activity
        plan.startH = startH
        plan.endH = endH
        plan.flag = flag
        plan.type = "E"
        
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
    
    
    
    
    func addPlanInDateMultiplo(activity : String , startH : NSDate,endH : NSDate, flag : NSString) {
        let date = cercaData(flag)
        let entityDescripition = NSEntityDescription.entityForName("Plan", inManagedObjectContext: managedObjectContext)
        var nuovoPlan = Plan(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        
        
        func salvaPlanInData() {
            let modelDate = date
            nuovoPlan.date = modelDate
            nuovoPlan.activity = activity
            nuovoPlan.startH = startH
            nuovoPlan.endH = endH
            nuovoPlan.flag = flag as String
            nuovoPlan.type = "E"
            modelDate!.addPlan(nuovoPlan)
            
            salvaContext()
        }
        salvaPlanInData()
        
    }
    
    
    func cercaData(flag : NSString) -> Date? {
        var data : Date?
        //var gestoreErrore = NSErrorPointer() // da utilizzare se vuoi gestire gli errori
        let request = NSFetchRequest(entityName: "Date")
        request.predicate = NSPredicate (format: "flag = %@",flag)
        request.returnsObjectsAsFaults = false
        
        let result :NSArray = try! managedObjectContext.executeFetchRequest(request)
        data = result[0] as? Date
        
        return data!
        
    }
    
    
    
    
    
    
    
    
    
    
}


