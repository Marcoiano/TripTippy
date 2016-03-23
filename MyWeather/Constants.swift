//
//  Constants.swift
//  Weather
//
//  Created by Marco Tabacchino on 28/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation


let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?q="
let BASE_KEY = "&units=Metric&appid=53444c274f8241e91a1bd93afdd85340"
let URL_BASE_FORECAST = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
let URL_FORECAST = "&units=Metric&cnt=5&appid=53444c274f8241e91a1bd93afdd85340"

let weatherIcon:Dictionary<Int,String> = [2: "Thunderstrom",
                                          3: "Drizzle",
                                          5: "Rain",
                                          6: "Snow",
                                          7: "Fog",
                                          800: "Sun",
                                          8: "Cloudy",
                                          9: "Attention"]

typealias DownloadComplete = () -> () //creating closure

