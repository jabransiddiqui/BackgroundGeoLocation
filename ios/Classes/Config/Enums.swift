//
//  Enums.swift
//  backgroundgeolocation
//
//  Created by Jibran SiddiQui on 13/10/2020.
//

import Foundation


//Enum  for location accuracy
enum locationAccuracy : String {
    case BestForNavigation = "kCLLocationAccuracyBestForNavigation"
    case AccuracyBest = "kCLLocationAccuracyBest"
    case NearestTenMeters = "kCLLocationAccuracyNearestTenMeters"
    case HundredMeters = "kCLLocationAccuracyHundredMeters"
    case Kilometer = "kCLLocationAccuracyKilometer"
    case ThreeKilometers = "kCLLocationAccuracyThreeKilometers"
}

//Enum  for location activity 
enum locationActivityType : String {
    
    case walk = "fitness"
    case automotive = "automotiveNavigation"
    case otherNavigations = "otherNavigation"
}
