//
//  PlanEventDetailsVC.swift
//  MyPlan
//
//  Created by Marco Tabacchino on 08/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI
import CoreLocation
import MapKit

class PlanEventDetailsVC : UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var currentObject : PFObject?
    var activity : String = ""
    var planFlag : NSString = ""
    var city : String = ""
    var startH : NSDate!
    var endH : NSDate!
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var eventNameDet: UILabel!
    
    @IBOutlet weak var thumbDet: PFImageView!
    
    @IBOutlet weak var infoDet: UILabel!
    
    @IBOutlet weak var startHLab: UILabel!
    
    @IBOutlet weak var endHLab: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameDet.text = activity
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH : mm a"
        startHLab.text = "From " +
            formatter.stringFromDate(startH)
        
        endHLab.text = "To " + formatter.stringFromDate(endH)
        showMust()
        
        
    }
    
    
    
    
    var locationManager = CLLocationManager()
    
    
    
    //MARK: *** let's look for other users ***
    
    var nearArray : [CLLocationCoordinate2D] = []
    
    func showMust() {
        PFQuery(className: city+"Events").whereKey("Name", equalTo: activity).findObjectsInBackgroundWithBlock ({
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
                        let span = MKCoordinateSpanMake(0.030, 0.030)
                        let region = MKCoordinateRegionMake(theirLocation, span)
                        self.mapView.setRegion(region, animated: true)
                        
                        let theirAnotation = MKPointAnnotation()
                        theirAnotation.coordinate = theirLocation
                        theirAnotation.title = key["Name"] as? String
                        
                        self.infoDet.text = key["Details"] as? String
                        self.address.text = key ["address"] as? String
                        
                        self.mapView.addAnnotation(theirAnotation)
                        
                        
                    }
                    
                    
                    
                }
                
                
            }
        })
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    
    
}


