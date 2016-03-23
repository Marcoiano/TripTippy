//
//  Weather.swift
//  Weather
//
//  Created by Marco Tabacchino on 28/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import Alamofire
class Weather{
    
    private var _city: String!
    private var _country: String!
    private var _weatherType: String!
    private var _currentTemp: String!
    private var _maxTemp: String!
    private var _minTemp: String!
    private var _windSpeed: String!
    private var _humidity: String!
    private var _currentUrl : String!
    private var _forcastUrl : String!
    private var _weatherIcon: Int!
    
    private var _1dayAfter: Weather!
    private var _2dayAfter: Weather!
    private var _3dayAfter: Weather!
    private var _4dayAfter: Weather!
    private var _5dayAfter: Weather!
    private var _6dayAfter: Weather!
    private var _7dayAfter: Weather!
    private var _8dayAfter: Weather!
    private var _9dayAfter: Weather!
    private var _10dayAfter: Weather!
    private var _11dayAfter: Weather!
    private var _12dayAfter: Weather!
    private var _13dayAfter: Weather!
    private var _14dayAfter: Weather!
    private var _15dayAfter: Weather!
    
    
    
    
    
    
    
    
    
    
    
    var city:String{
        return _city
    }
    
    var country:String{
        return _country
    }
    
    var weatherType:String{
        return _weatherType
    }
    
    var currentTemp:String{
        return _currentTemp
    }
    
    var maxTemp:String{
        return _maxTemp
    }
    
    var minTemp:String{
        return _minTemp
    }
    
    var windSpeed:String{
        return _windSpeed
    }
    
    var humidity:String{
        return _humidity
    }
    
    var currentUrl:String{
        return _currentUrl
    }
    
    var forcastUrl:String{
        return _forcastUrl
    }
    
    var weatherIcon:Int{
        return _weatherIcon
    }
    
    var oneDayAfter: Weather {
        return _1dayAfter
    }
    
    var twoDayAfter: Weather{
        return _2dayAfter
    }
    
    var threeDayAfter: Weather{
        return _3dayAfter
    }
    
    var fourDayAfter: Weather{
        return _4dayAfter
    }
    var fiveDayAfter: Weather {
        return _1dayAfter
    }
    
    var sixDayAfter: Weather{
        return _2dayAfter
    }
    
    var sevenDayAfter: Weather{
        return _3dayAfter
    }
    
    var eigthDayAfter: Weather{
        return _4dayAfter
    }
    var nineDayAfter: Weather {
        return _1dayAfter
    }
    
    var tenDayAfter: Weather{
        return _2dayAfter
    }
    
    var elevenDayAfter: Weather{
        return _3dayAfter
    }
    
    var twelveDayAfter: Weather{
        return _4dayAfter
    }
    var tteenDayAfter: Weather {
        return _1dayAfter
    }
    
    var fteeDayAfter: Weather{
        return _2dayAfter
    }
    
    var vteenDayAfter: Weather{
        return _3dayAfter
    }
    
    
    
    
    
    init(name: String)
    {
        self._city = name
        let url = URL_BASE+self._city+BASE_KEY
        _currentUrl = url
        _forcastUrl = URL_BASE_FORECAST+self._city+URL_FORECAST
        /*
         self._1dayAfter = Weather(name: self._city)
         self._2dayAfter = Weather(name: self._city)
         self._3dayAfter = Weather(name: self._city)
         self._4dayAfter = Weather(name: self._city)
         */
        
        
        
    }
    
    func downloadWeatherDetails(completed: DownloadComplete){
        let url = NSURL(string: self._currentUrl)!
        
        //let manager = Alamofire.Manager.sharedInstance
        print("did we call function")
        print(url)
        //current data
        Alamofire.request(.GET, url).responseJSON{
            response in let result = response.result
            print(result.value)
            if let dict = result.value as? Dictionary<String, AnyObject>{
                //City
                if let Name = dict["name"] as? String{
                    self._city = Name
                    print(self._city)
                }
                //Country
                if let sys = dict["sys"] as? Dictionary<String,AnyObject>{
                    if let Country = sys["country"] as? String{
                        self._country = Country
                        print(self._country)
                    }
                }
                //if let weather
                //currentTemp
                if let CurrentTemp = dict["main"] as? Dictionary<String,AnyObject>{
                    if let temp = CurrentTemp["temp"] as? Int{
                        // temp = (temp - 32) * 5/9
                        self._currentTemp = "\(temp)°C"
                        print(self._currentTemp)
                    }
                    if let Humidity = CurrentTemp["humidity"] as? Int{
                        self._humidity = "\(Humidity)%"
                        print(self._humidity)
                    }
                    
                }
                
                if let wind = dict["wind"] as? Dictionary<String,AnyObject>{
                    if let WindSpeed = wind["speed"] as? Int{
                        self._windSpeed = "\(WindSpeed)MPH"
                        print(self._windSpeed)
                    }
                }
                
                if let weatherInfo = dict["weather"] as? [Dictionary<String,AnyObject>]{
                    if let icon = weatherInfo[0]["id"] as? Int{
                        if icon == 800{
                            self._weatherIcon = icon
                        }
                        else {
                            self._weatherIcon = icon/100
                        }
                        
                        print(self._weatherIcon)
                    }
                }
                
            }
            completed()
            //print(result)
        }
        
    }
    
    
    
    func downloadForecastWeatherDetails(completed: DownloadComplete){
        let url = NSURL(string: self._forcastUrl)!
        
        //let manager = Alamofire.Manager.sharedInstance
        print("did we call function")
        print(url)
        //current data
        
        Alamofire.request(.GET, url).responseJSON{
            response in let result = response.result
            print(result.value)
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let Temp = dict["list"] as? [Dictionary<String,AnyObject>]
                    where Temp.count > 0{
                    if let today = Temp[0]["temp"] as? Dictionary<String,AnyObject>{
                        if let tempMax = today["max"] as? Int{
                            self._maxTemp = "\(tempMax)°"
                            print(self._maxTemp)
                        }
                        if let tempMin = today["min"] as? Int{
                            self._minTemp = "\(tempMin)°"
                            print(self._minTemp)
                        }
                    }
                    
                    self._1dayAfter = Weather(name: self._city)
                    if let oneDay = Temp[1]["temp"] as? Dictionary<String,AnyObject>{
                        if let tempMax = oneDay["max"] as? Int{
                            self._1dayAfter._maxTemp = "\(tempMax)°"
                            print(self._1dayAfter._maxTemp)
                        }
                        if let tempMin = oneDay["min"] as? Int{
                            self._1dayAfter._minTemp = "\(tempMin)°"
                            print(self._1dayAfter._minTemp)
                            
                        }
                        if let weatherInfo = Temp[1]["weather"] as? [Dictionary<String,AnyObject>]{
                            if let icon = weatherInfo[0]["id"] as? Int{
                                print(icon)
                                if icon == 800{ self._1dayAfter._weatherIcon = icon}
                                else {self._1dayAfter._weatherIcon = icon/100}
                                print(self._1dayAfter._weatherIcon)
                            }
                        }
                    }
                    
                    
                    self._2dayAfter = Weather(name: self._city)
                    if let twoDay = Temp[2]["temp"] as? Dictionary<String,AnyObject>{
                        if let tempMax = twoDay["max"] as? Int{
                            self._2dayAfter._maxTemp = "\(tempMax)°"
                            
                        }
                        if let tempMin = twoDay["min"] as? Int{
                            self._2dayAfter._minTemp = "\(tempMin)°"
                            print(self._2dayAfter._minTemp)
                        }
                        if let weatherInfo = Temp[2]["weather"] as? [Dictionary<String,AnyObject>]{
                            if let icon = weatherInfo[0]["id"] as? Int{
                                print(icon)
                                if icon == 800{ self._2dayAfter._weatherIcon = icon}
                                else {self._2dayAfter._weatherIcon = icon/100}
                                print(self._2dayAfter._weatherIcon)
                            }
                        }
                    }
                    
                    self._3dayAfter = Weather(name: self._city)
                    if let threeDay = Temp[3]["temp"] as? Dictionary<String,AnyObject>{
                        if let tempMax = threeDay["max"] as? Int{
                            self._3dayAfter._maxTemp = "\(tempMax)°"
                            print(self._3dayAfter._maxTemp)
                        }
                        if let tempMin = threeDay["min"] as? Int{
                            self._3dayAfter._minTemp = "\(tempMin)°"
                            print(self._3dayAfter._minTemp)
                        }
                        if let weatherInfo = Temp[3]["weather"] as? [Dictionary<String,AnyObject>]{
                            if let icon = weatherInfo[0]["id"] as? Int{
                                print(icon)
                                if icon == 800{ self._3dayAfter._weatherIcon = icon}
                                else {self._3dayAfter._weatherIcon = icon/100}
                                print(self._3dayAfter._weatherIcon)
                            }
                        }
                    }
                    
                    
                    self._4dayAfter = Weather(name: self._city)
                    if let fourDay = Temp[4]["temp"] as? Dictionary<String,AnyObject>{
                        if let tempMax = fourDay["max"] as? Int{
                            self._4dayAfter._maxTemp = "\(tempMax)°"
                            print(self._4dayAfter._maxTemp)
                        }
                        
                        if let tempMin = fourDay["min"] as? Int{
                            self._4dayAfter._minTemp = "\(tempMin)°"
                            print(self._4dayAfter._minTemp)
                        }
                        
                        if let weatherInfo = Temp[4]["weather"] as? [Dictionary<String,AnyObject>]{
                            if let icon = weatherInfo[0]["id"] as? Int{
                                print(icon)
                                if icon == 800{ self._4dayAfter._weatherIcon = icon}
                                else {self._4dayAfter._weatherIcon = icon/100}
                                print(self._4dayAfter._weatherIcon)
                            }
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
            }
            completed()
            
        }
    }
    
    
    
}