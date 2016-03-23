//
//  MapViewController.swift
//  Main
//
//  Created by Marco Tabacchino on 29/09/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    var city : String = ""
    
    @IBOutlet weak var viewMap: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.viewMap?.showsUserLocation = true
        
        /* var radius = 100.0
         let point = locationManager.location
         
         let myGeoPoint = PFGeoPoint(latitude: (point?.coordinate.latitude)!, longitude: (point?.coordinate.longitude)!) */
        var nearArray : [CLLocationCoordinate2D] = []
        func filterByProximity() {
            PFQuery(className: city+"Must").whereKeyExists("MustLocation")
                .findObjectsInBackgroundWithBlock ({
                    objects, error in
                    if let proximityArray = objects as? [PFObject] {
                        //                        println("****** here the proximity matches: \(proximityArray)")
                        for loc in proximityArray {
                            //                            println("here they are \(near)")
                            
                            let position = loc["MustLocation"] as? PFGeoPoint
                            
                            let theirLat = position?.latitude       //this is an optional
                            let theirLong = position?.longitude     //this is an optional
                            let theirLocation = CLLocationCoordinate2D(latitude: theirLat!, longitude: theirLong!)
                            
                            nearArray.append(theirLocation)
                            
                            if nearArray.isEmpty {
                                print("*** ERROR! anyone close by ***")
                            } else
                            {
                                for _ in nearArray {
                                    
                                    let span = MKCoordinateSpanMake(1.50, 1.50)
                                    let region = MKCoordinateRegionMake(theirLocation, span)
                                    self.viewMap.setRegion(region, animated: true)
                                    
                                    let theirAnotation = MKPointAnnotation()
                                    theirAnotation.coordinate = theirLocation
                                    theirAnotation.title = loc["Name"] as? String
                                    
                                    self.viewMap.addAnnotation(theirAnotation)
                                }
                                
                            }
                            
                            
                            
                        }
                        //print("****** in a radius of \(radius) there are \(nearArray.count) bikers ******")
                        
                    }
                })
        }
        
        filterByProximity()
        
        
        
        
        
    }
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.viewMap?.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                print("Error: " + error!.localizedDescription, terminator: "")
                return
            }
            
            if let pm = placemarks?.first {
                self.displayLocationInfo(pm)
                
            }
            else
            {
                print("Error with the data.", terminator: "")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        
        self.locationManager.stopUpdatingLocation()
        print(placemark.name, terminator: "")
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
