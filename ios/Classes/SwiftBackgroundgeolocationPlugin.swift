//
//  SwiftBackgroundgeolocationPlugin.swift
//  backgroundgeolocation
//
//  Created by Jibran SiddiQui on 13/10/2020.
//

import Flutter
import UIKit
import CoreLocation

public class SwiftBackgroundgeolocationPlugin: NSObject, FlutterPlugin {
    
    //Variables
    var eventSink : FlutterEventSink?
    var listeningOnChanged =  false
    private var locationService : LocationService?

  //Register the Plugin in iOS
  public static func register(with registrar: FlutterPluginRegistrar) {
   let channel =  FlutterMethodChannel(name : "com_backgroundlocation/method" , binaryMessenger: registrar.messenger())
    let stream =  FlutterEventChannel(name : "com_backgroundlocation/stream" , binaryMessenger: registrar.messenger())
    let instance =  SwiftBackgroundgeolocationPlugin()
    registrar.addMethodCallDelegate (instance, channel : channel)
    stream.setStreamHandler(instance)
  }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if call.method == "stopLocation"{
        var message = ""
        if listeningOnChanged == true {
          if let service = locationService {
            message = service.stopUpdatingLocation()
            self.locationService = nil
          }else{
             message = "Location haven't start yet"
          }
        }else{
          message = "Location haven't start yet"
        }
        result(message)
      }
    }
}

//MARK : Stream Handler
extension SwiftBackgroundgeolocationPlugin : FlutterStreamHandler{
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
       if let args = arguments as? Array <Any>{
           if args.count > 0 {
               if let eventName =  args[0] as? String{
                   if eventName == "on_changed" {
                     if args.count > 1 {
                       self.eventSink = events
                       if let params = args[1] as? [String : Any] {
                         self.locationService = LocationService(config : params)
                       }else{
                         self.locationService = LocationService(config : [:])
                       }
                       if let service = self.locationService {
                         let _ = service.stopUpdatingLocation()
                         NotificationCenter.default.removeObserver(self)
                         service.startUpdatingLocation()
                       }
                       NotificationCenter.default.addObserver(self, selector: #selector(updateLocation(notification:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
                       self.listeningOnChanged =  true
                     }else{
                       self.eventSink = events
                       self.locationService = LocationService(config : [:])
                       if let service = self.locationService {
                           let _ = service.stopUpdatingLocation()
                           NotificationCenter.default.removeObserver(self)
                           service.startUpdatingLocation()
                       }
                       NotificationCenter.default.addObserver(self, selector: #selector(updateLocation(notification:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
                       self.listeningOnChanged =  true
                     }
                   }
               }
           }
       }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        let _ = locationService?.stopUpdatingLocation()
        eventSink = nil
        return nil
    }
    
    //Update locations
    @objc func updateLocation(notification: NSNotification){
         if let userInfo = notification.userInfo{
             if let newLocation = userInfo["location"] as? CLLocation{
             guard let eventSink = self.eventSink else {
               return
             }
             eventSink([
                 "lat" : newLocation.coordinate.latitude,
                 "lng" : newLocation.coordinate.longitude
             ])
            }
        }
    }
    
}
