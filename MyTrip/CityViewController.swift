//
//  CityViewController.swift
//  MyTrip
//
//  Created by Marco Tabacchino on 02/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CityViewController: UITableViewController, UISearchResultsUpdating
{
    let city = ["Roma","Firenze","Milano", "Torino","Rimini", "Perugia"]
    var filteredAppleProducts = [String]()
    var resultSearchController = UISearchController()
    var trip : Trip?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.resultSearchController.active)
        {
            return self.filteredAppleProducts.count
        }
        else
        {
            return self.city.count
        }
    }
    var valueToPass: String!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        if (self.resultSearchController.active)
        {
            cell!.textLabel?.text = self.filteredAppleProducts[indexPath.row]
            
            return cell!
        }
        else
        {
            
            cell!.textLabel?.text = self.city[indexPath.row]
            
            return cell!
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        let createTrip = CreateTripViewController()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        var cityItem : String
        
        
        
        
        if (self.resultSearchController.active)
        {
            cityItem = self.filteredAppleProducts[indexPath.row]
            
            
            
            
        }
        else
        {
            cityItem = self.city[indexPath.row]
        }
        
        valueToPass = cityItem
        createTrip.receivedString = valueToPass
        self.performSegueWithIdentifier("next", sender: cityItem)
        
        
    }
    
    
    
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.city as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredAppleProducts = array as! [String]
        
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "next") {
            
            
            let tripController = segue.destinationViewController as? CreateTripViewController
            
            tripController?.receivedString = valueToPass
        }
    }
    @IBAction func backToMain(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = ContainerViewController()
        
        
    }
    
    
    
    
    
}
