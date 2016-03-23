//
//  MosaicPlanViewController.swift
//  MyPlan
//
//  Created by Marco Tabacchino on 23/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class MosaicPlanViewController : UIViewController {
    
    var trip : Trip?
    var plan : Plan?
    var date : Date?
    var flag : NSString = ""
    var tripFlag : NSString = ""
    var city : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func goToFav(sender: AnyObject) {
        let myFavPage = self.storyboard?.instantiateViewControllerWithIdentifier("FavViewController") as! FavoriteViewController
        
        let myFavPageNav = UINavigationController(rootViewController: myFavPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = myFavPageNav
        
        myFavPage.tripFlag = flag
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print ("il flag è: \(flag)")
        print ("il tripFlag é \(tripFlag)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if  segue.identifier == "goToMust" {
            let mustController : MustViewController = segue.destinationViewController as! MustViewController
            mustController.flag = flag
            mustController.city = city
            mustController.tripFlag = tripFlag
            
            
        } else if segue.identifier == "goToEvents" {
            let eventController : EventsViewController = segue.destinationViewController as! EventsViewController
            eventController.flag = flag
            eventController.city = city
            eventController.tripFlag = tripFlag
            
        }
        else if segue.identifier == "goToFav" {
            let favController : FavoriteViewController = segue.destinationViewController as! FavoriteViewController
            favController.tripFlag = flag
            favController.city = city
            favController.trip = trip
            
        }
        else if segue.identifier == "goToMap" {
            let mapController : MapViewController = segue.destinationViewController as! MapViewController
            mapController.city = city
        }
        
    }
}


