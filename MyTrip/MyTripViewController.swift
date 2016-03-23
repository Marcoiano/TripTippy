//
//  MyTripViewController.swift
//  MyTrip
//
//  Created by Marco Tabacchino on 06/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MyTripViewController : UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    var cityWeather : Weather = Weather(name: "")
    var forecastUrl : String = ""
    var startDate : NSDate!
    var endDate : NSDate!
    
    
    var trip : Trip?
    @IBOutlet var Time: UILabel!
    @IBOutlet var Date: UILabel!
    @IBOutlet var WeatherType: UIImageView!
    @IBOutlet var TempNow: UILabel!
    @IBOutlet var TempMax: UILabel!
    @IBOutlet var TempMin: UILabel!
    @IBOutlet var Humidity: UILabel!
    @IBOutlet var WindSpeed: UILabel!
    
    @IBOutlet var oneDayDate: UILabel!
    @IBOutlet var oneDayIcon: UIImageView!
    @IBOutlet var oneDayMax: UILabel!
    @IBOutlet var oneDayMin: UILabel!
    
    @IBOutlet var twoDayDate: UILabel!
    @IBOutlet var twoDayIcon: UIImageView!
    @IBOutlet var twoDayMax: UILabel!
    @IBOutlet var twoDayMin: UILabel!
    
    @IBOutlet var threeDayDate: UILabel!
    @IBOutlet var threeDayIcon: UIImageView!
    @IBOutlet var threeDayMax: UILabel!
    @IBOutlet var threeDayMin: UILabel!
    
    
    @IBOutlet var fourDayDate: UILabel!
    @IBOutlet var fourDayIcon: UIImageView!
    @IBOutlet var fourDayMax: UILabel!
    @IBOutlet var fourDayMin: UILabel!
    
    
    
    @IBOutlet weak var showCity: UILabel!
    var city : String = ""
    var arrDate : NSDate!
    var depDate : NSDate!
    var tripFlag : NSString = ""
    
    @IBOutlet weak var backgroundCity: UIImageView!
    
    
    
    @IBAction func backToMain(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = ContainerViewController()
        
        
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showCity.text = city
        if (city == "Roma") {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "roma")!)
        }
        if (city == "Firenze") {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "firenze")!)
        }
        
        if (city == "Milano") {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "milano")!)
        }
        
        if (city == "Torino") {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "torino")!)
        }
        
        if (city == "Rimini") {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "rimini")!)
        }
        
        if (city == "Perugia") {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "perugia")!)
        }
        
        
        
        
        
    }
    
    //activities
    
    
    var objects: NSMutableArray! = NSMutableArray()
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showPlan" {
            let currentWeather:String = weatherIcon[cityWeather.weatherIcon]!
            let oneDayWeather:String = weatherIcon[cityWeather.oneDayAfter.weatherIcon]!
            let twoDayWeather:String = weatherIcon[cityWeather.twoDayAfter.weatherIcon]!
            let threeDayWeather:String = weatherIcon[cityWeather.threeDayAfter.weatherIcon]!
            let fourDayWeather:String = weatherIcon[cityWeather.fourDayAfter.weatherIcon]!
            let icons : [String] = [currentWeather,oneDayWeather,twoDayWeather, threeDayWeather,fourDayWeather]
            
            let tempMaxs : [String] = [cityWeather.maxTemp,cityWeather.oneDayAfter.maxTemp, cityWeather.twoDayAfter.maxTemp,cityWeather.threeDayAfter.maxTemp, cityWeather.fourDayAfter.maxTemp]
            
            let tempMins : [String] = [cityWeather.minTemp,cityWeather.oneDayAfter.minTemp, cityWeather.twoDayAfter.minTemp,cityWeather.threeDayAfter.minTemp, cityWeather.fourDayAfter.minTemp]
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMddYY"
            let flagDate = formatter.stringFromDate(startDate)
            
            appDelegate.startDate = startDate
            appDelegate.endDate = endDate
            appDelegate.city = city
            appDelegate.trip = trip
            appDelegate.icons = icons
            appDelegate.tempMaxs = tempMaxs
            appDelegate.tempMins = tempMins
            appDelegate.tripFlag = tripFlag
            appDelegate.tripFlag = city+flagDate
            appDelegate.cityWeather = cityWeather
            
        } else if segue.identifier == "goToMap" {
            let mapController : MapViewController = segue.destinationViewController as! MapViewController
            mapController.city = city
        }
        
    }
    
    
    //CODICE METEO
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmr:NSTimer = NSTimer.scheduledTimerWithTimeInterval(
            2.0,
            target: self,
            selector: #selector(MyTripViewController.CurrentTime(_:)),
            userInfo: nil,
            repeats: true)
        tmr.fire()
        print("did we get here1")
        
        
        cityWeather = Weather(name: city)
        cityWeather.downloadWeatherDetails{ () -> () in
            
            self.cityWeather.downloadForecastWeatherDetails{ () -> () in
                print("did we get here2")
                self.updateUI();
                
            }
            
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func updateUI(){
        let currentWeather:String = weatherIcon[cityWeather.weatherIcon]!
        WeatherType.image = UIImage(named: currentWeather)
        TempNow.text = cityWeather.currentTemp
        TempMax.text = cityWeather.maxTemp
        TempMin.text = cityWeather.minTemp
        Humidity.text = cityWeather.humidity
        WindSpeed.text = cityWeather.windSpeed
        
        
        let oneDayWeather:String = weatherIcon[cityWeather.oneDayAfter.weatherIcon]!
        oneDayIcon.image = UIImage(named: oneDayWeather)
        oneDayMax.text = cityWeather.oneDayAfter.maxTemp
        oneDayMin.text = cityWeather.oneDayAfter.minTemp
        
        let twoDayWeather:String = weatherIcon[cityWeather.twoDayAfter.weatherIcon]!
        twoDayIcon.image = UIImage(named: twoDayWeather)
        twoDayMax.text = cityWeather.twoDayAfter.maxTemp
        twoDayMin.text = cityWeather.twoDayAfter.minTemp
        
        let threeDayWeather:String = weatherIcon[cityWeather.threeDayAfter.weatherIcon]!
        threeDayIcon.image = UIImage(named: threeDayWeather)
        threeDayMax.text = cityWeather.threeDayAfter.maxTemp
        threeDayMin.text = cityWeather.threeDayAfter.minTemp
        
        let fourDayWeather:String = weatherIcon[cityWeather.fourDayAfter.weatherIcon]!
        fourDayIcon.image = UIImage(named: fourDayWeather)
        fourDayMax.text = cityWeather.fourDayAfter.maxTemp
        fourDayMin.text = cityWeather.fourDayAfter.minTemp
        
        
    }
    
    func CurrentTime(timer:NSTimer){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let dateComponent = calendar.components(NSCalendarUnit.Weekday, fromDate: date)
        let weekday = dateComponent.weekday
        let weekDay:Dictionary = [1: "Sunday",
                                  2: "Monday",
                                  3: "Tuesday",
                                  4: "Wednesday",
                                  5: "Thurseday",
                                  6: "Friday",
                                  7: "Saturday"]
        
        let weekDayAbbr:Dictionary = [0: "SUN",
                                      1: "MON",
                                      2: "TUES",
                                      3: "WED",
                                      4: "THUR",
                                      5: "FRI",
                                      6: "SAT"]
        
        Time.text = formatter.stringFromDate(date)
        Date.text = weekDay[weekday]
        oneDayDate.text = weekDayAbbr[(weekday)%7]
        twoDayDate.text = weekDayAbbr[(weekday+1)%7]
        threeDayDate.text = weekDayAbbr[(weekday+2)%7]
        fourDayDate.text = weekDayAbbr[(weekday+3)%7]
    }
    
    
}























