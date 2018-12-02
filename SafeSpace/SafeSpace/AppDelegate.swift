//
//  AppDelegate.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


var sweetBlue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)

let sweetGreen = UIColor(red:0.3, green:0.8, blue:0.13, alpha:1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyCJsjC1xVGvKCgEFABt6h9Acjy2JKkY-Fo")
        GMSPlacesClient.provideAPIKey("AIzaSyCJsjC1xVGvKCgEFABt6h9Acjy2JKkY-Fo")
        
        /*NetworkManager.sharedInstance.getLocation(googlePlaceID: "6") { json in
            print("LOCATION: \(json["location"]!)")
            print("INFO: \(json["information"]!)")
        }*/
        
        /*let locationParams = ["location_type_name":"park", "name":"Gleiche's Lodge", "address":"6969 Pleasureville", "city":"New Haven", "state":"CT", "zip":"06880", "lat":6989.6969, "long":8969.969, "google_place_id":"888"] as [String : Any]
        NetworkManager.sharedInstance.addLocation(locationParams: locationParams) { json in
            print("ADD LOCATION RESPONSE: \(json)")
        }*/
        
        /*let locationParams = ["location_type_name":"park", "name":"Gleiche's Lodge", "address":"6969 Pleasureville", "city":"New Haven", "state":"CT", "zip":"06880", "lat":6989.6969, "long":8969.969, "google_place_id":"888"] as [String : Any]
        NetworkManager.sharedInstance.updateLocation(locationID: 60, locationParams: locationParams) { json in
            print("UPDATE LOCATION RESPONSE: \(json)")
        }*/
        
        /*let informationParams = ["google_place_id":5, "description":"DESCRIPTION", "ramps":true, "score":0.7777] as [String : Any]
        NetworkManager.sharedInstance.addInformation(informationParams: informationParams) { json in
            print("ADD INFO RESPONSE: \(json)")
        }*/
        
        /*let informationParams = ["google_place_id":5, "description":"DESCRIPTION", "ramps":true, "score":0.7777] as [String : Any]
        NetworkManager.sharedInstance.updateInformation(informationID: 2, informationParams: informationParams) { json in
            print("UPDATE INFO RESPONSE: \(json)")
        }*/
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

