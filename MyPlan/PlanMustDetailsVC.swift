//
//  PlanMustDetailsVC.swift
//  MyPlan
//
//  Created by Marco Tabacchino on 23/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//


import UIKit
import CoreData
import Parse
import ParseUI
import CoreLocation
import MapKit

class PlanMustDetailsVC : UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate
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
    
    @IBOutlet weak var mustNameDet: UILabel!
    
    @IBOutlet weak var thumbDet: PFImageView!
    
    @IBOutlet weak var infoDet: UILabel!
    
    @IBOutlet weak var startHLab: UILabel!
    
    @IBOutlet weak var opHours: UILabel!
    
    @IBOutlet weak var endHLab: UILabel!
    
    @IBOutlet weak var admission: UILabel!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mustNameDet.text = activity
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
        PFQuery(className: city+"Must").whereKey("Name", equalTo: activity).findObjectsInBackgroundWithBlock ({
            objects, error in
            if let cityMust = objects as? [PFObject] {
                //                        println("****** here the proximity matches: \(proximityArray)")
                for key in cityMust {
                    //                            println("here they are \(near)")
                    let position = key["MustLocation"] as? PFGeoPoint
                    
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
                        
                        let initialThumbnail = UIImage(named: "question")
                        self.thumbDet.image = initialThumbnail
                        if let thumbnail = key["thumb"] as? PFFile {
                            self.thumbDet.file = thumbnail
                            self.thumbDet.loadInBackground()
                        }
                        
                        
                        self.infoDet.text = key["Information"] as? String
                        self.opHours.text = key["OpeningHours"] as? String
                        self.admission.text = key["Admission"] as? String
                        self.address.text = key ["Address"] as? String
                        
                        self.mapView.addAnnotation(theirAnotation)
                        
                        
                    }
                    
                    
                    
                }
                
                
            }
        })
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        print ("il nome è: \(mustNameDet.text!)")
        print ("il planFlag è: \(planFlag)")
    }
    
    
    
    
}

