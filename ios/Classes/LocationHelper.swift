//
//  LocationHelper.swift
//  backgroundgeolocation
//
//  Created by Jibran SiddiQui on 13/10/2020.
//

import Foundation
import CoreLocation


// Location Helper
class LocationHelper: NSObject {
    
    static let shared = LocationHelper() // Singleton
    
    
    private override init() {} // Initialzation
    
    func initLocationManager(_ config : [String : Any]) -> CLLocationManager {
        
       let locationManager: CLLocationManager = CLLocationManager() // instance of Location  Manager
        
        // Desired Accuracy
        if let accuracy = config["desiredAccuracy"] as? String {
             switch locationAccuracy(rawValue: accuracy) {
             case .BestForNavigation:
                 locationManager.desiredAccuracy = kCLLocationAccuracyBest
             case .AccuracyBest:
                 locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
             case .NearestTenMeters :
                 locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
             case .HundredMeters :
                 locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
             case .Kilometer :
                 locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
             case .ThreeKilometers :
                 locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
             default:
                 locationManager.desiredAccuracy = kCLLocationAccuracyBest
             }
         }else{// default
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
         }
        
         //Activity Type
         if let activityType = config["activityType"] as? String {
             switch locationActivityType(rawValue: activityType) {
             case .walk:
                 locationManager.activityType = .fitness
             case .automotive :
                 locationManager.activityType = .automotiveNavigation
             case .otherNavigations :
                 locationManager.activityType = .otherNavigation
             default:
                 locationManager.activityType = .other
             }
         }else{
             locationManager.activityType = .fitness
         }
         
         //Distance Filter
         if let distanceFilter  = config["distanceFilter"] as? Double {
             locationManager.distanceFilter = distanceFilter
         }else{// default
             locationManager.distanceFilter = kCLDistanceFilterNone
         }
         
         //Background Location update
         if #available(iOS 9.0, *) {
              if let isBackground = config["allowBackgroundLocation"] as?  Bool{
                 locationManager.allowsBackgroundLocationUpdates = isBackground
              }else{
                 locationManager.allowsBackgroundLocationUpdates = false
             }
         } else {
             // Fallback on earlier versions
         }
         
         //Pause location updation automatically
         if let isPauseAuto = config["pauseLocationAuto"] as?  Bool{
             locationManager.pausesLocationUpdatesAutomatically = isPauseAuto
         }else{
             locationManager.pausesLocationUpdatesAutomatically = false
         }
         
         //show indication
         if #available(iOS 11.0, *) {
             if let showIndicator = config["showsBackgroundLocationIndicator"] as?  Bool{
                 locationManager.showsBackgroundLocationIndicator = showIndicator
              }else{// Desired Accuracy
                 locationManager.showsBackgroundLocationIndicator = false
             }
         } else {
             // Fallback on earlier versions
             
         }
        return locationManager //return configured instance of location manager
    }
}
