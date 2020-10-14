//
//  LocationService.swift
//  backgroundgeolocation
//
//  Created by Jibran SiddiQui on 13/10/2020.
//

import UIKit
import CoreLocation

class LocationService : NSObject {
    
    var locationManager: CLLocationManager?
    var isUpdatingLocation : Bool = false
    var useFilter: Bool =  true
    var horizontalAccuracy : Int = 0
    init(config : [String : Any]){
        //init location manager with confi or defaluts
        locationManager =  LocationHelper.shared.initLocationManager(config)
        super.init()
        if let _ = locationManager{
            checkUsersLocationServicesAuthorization()
        }
        self.locationManager?.delegate = self
    }
    deinit {
        let _ = self.stopUpdatingLocation()
        self.locationManager = nil
        self.isUpdatingLocation = false
    }
    
     func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            if isUpdatingLocation{
                //location are already updating
            }else{
                self.isUpdatingLocation = true
                locationManager?.startUpdatingLocation()
            }
            
        }else{
            //tell view controllers to show an alert
        }
    }
    func stopUpdatingLocation() -> String {
        if isUpdatingLocation {
            locationManager?.stopUpdatingLocation()
            return "Location stop successfully"
        }else{
            //location is not started yet
            return "Location haven't start yet"
        }
    }
    
    func checkUsersLocationServicesAuthorization(){
        /// Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                self.locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                break

            case .restricted, .denied:
                    self.showTurnOnLocationServiceAlert()
                break

            case .authorizedWhenInUse, .authorizedAlways:
                // Enable features that require location services here.
                print("Full Access")
                break
            @unknown default:
                break
            }
        }
    }

    func showTurnOnLocationServiceAlert(){
        // Disable location features
        let alert = UIAlertController(title: "Allow Location Access", message: "App needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {return}
            if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}

//MARK: CLLocationManagerDelegate protocol methods
extension LocationService : CLLocationManagerDelegate{
    
     
    func locationManager(_ manager: CLLocationManager,
                                     didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
            
            var locationAdded: Bool
            if useFilter{
                locationAdded = filterAndAddLocation(newLocation)
            }else{
                locationAdded = true
            }
            
            if locationAdded{
                notifiyDidUpdateLocation(newLocation: newLocation)
            }
            
        }
    }
    func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error){
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
            //User denied your app access to location information.
          
        }
    }

    func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            
        }else if status == .authorizedAlways {
            
        }else if status == .denied {
            self.showTurnOnLocationServiceAlert()
        }else if status == .notDetermined {
            self.showTurnOnLocationServiceAlert()
        }else if status == .restricted {
            self.showTurnOnLocationServiceAlert()
        }
    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool{
        let age = -location.timestamp.timeIntervalSinceNow
        
        if age > 10{
            print("Locaiton is old.")
            return false
        }
        
        if location.horizontalAccuracy < 0{
            print("Latitidue and longitude values are invalid.")
            return false
        }
        
        if location.horizontalAccuracy > 100{
            print("Accuracy is too low.")
            return false
        }
        
        print("Location quality is good enough.")
        
        return true
        
    }
    
    func notifiyDidUpdateLocation(newLocation:CLLocation){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
    }
}
