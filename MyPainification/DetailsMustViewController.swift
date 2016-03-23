//
//  DetailsMustViewController.swift
//  MyPianification
//
//  Created by Marco Tabacchino on 13/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//


import UIKit
import CoreData
import Parse
import ParseUI
import CoreLocation
import MapKit


class DetailsMustViewController : UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var currentObject : PFObject?
    var date : Date?
    var flag : NSString = ""
    var tripFlag : NSString = ""
    var city : String = ""
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    var postTitle: String!
    var postBody: String!
    
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var mustNameDet: UILabel!
    
    @IBOutlet weak var thumbDet: PFImageView!
    
    
    @IBOutlet weak var infoDet: UILabel!
    
    @IBOutlet weak var startHPic: UIDatePicker!
    
    @IBOutlet weak var endHPic: UIDatePicker!
    
    
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    @IBOutlet weak var opHours: UILabel!
    
    
    @IBOutlet weak var admission: UILabel!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unwrap the current object object
        if let object = currentObject {
            mustNameDet.text = object["Name"] as? String
            infoDet.text = object["Information"] as? String
            opHours.text = object["OpeningHours"] as? String
            admission.text = object["Admission"] as? String
            address.text = object ["Address"] as? String
            let initialThumbnail = UIImage(named: "question")
            thumbDet.image = initialThumbnail
            if let thumbnail = object["thumb"] as? PFFile {
                thumbDet.file = thumbnail
                thumbDet.loadInBackground()
            }
            
            
        }
        
        var locationManager = CLLocationManager()
        
        
        
        //MARK: *** let's look for other users ***
        
        var nearArray : [CLLocationCoordinate2D] = []
        
        func showMustLocation() {
            PFQuery(className: city+"Must").whereKey("Name", equalTo: mustNameDet.text!).findObjectsInBackgroundWithBlock ({
                objects, error in
                if let cityMust = objects as? [PFObject] {
                    //                        println("****** here the proximity matches: \(proximityArray)")
                    for loc in cityMust {
                        //                            println("here they are \(near)")
                        
                        let position = loc["MustLocation"] as? PFGeoPoint
                        
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
                            theirAnotation.title = loc["Name"] as? String
                            
                            
                            self.mapView.addAnnotation(theirAnotation)
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
            })
        }
        
        showMustLocation()
        
        
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
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
        
        print ("il flag è: \(flag)")
        print ("il nome è: \(mustNameDet.text!)")
        print ("il trip flag è: \(tripFlag)")
    }
    
    
    
    @IBAction func addToFav(sender: AnyObject) {
        createFav(mustNameDet.text!, tripFlag: tripFlag as String)
        addFavInTrip(mustNameDet.text!, tripFlag: tripFlag)
        
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
        favorite.type = "M"
        
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
            nuovoFav.type = "M"
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
        //createPlan(mustNameDet.text!, startH : startHPic.date, endH : endHPic.date, flag : flag as String)
        addPlanInDateMultiplo(mustNameDet.text!, startH: startHPic.date, endH: endHPic.date, flag: flag)
        let alert = UIAlertController(title: "Event added correctly", message: "", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) {
            UIAlertAction in
            self.navigationController!.popViewControllerAnimated(true)
        }
        alert.addAction(okAction)
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        //self.dismissViewControllerAnimated(true, completion: {})
        
        //self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    func createPlan(activity : String , startH : NSDate, endH : NSDate, flag : String) {
        let entityDescripition = NSEntityDescription.entityForName("Plan", inManagedObjectContext: managedObjectContext)
        let plan = Plan(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        plan.activity = activity
        plan.startH = startH
        plan.endH = endH
        plan.flag = flag
        plan.type = "M"
        
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
            nuovoPlan.type = "M"
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

