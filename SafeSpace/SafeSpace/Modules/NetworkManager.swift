//
//  dataStore.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import Foundation
import GooglePlaces
import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var selectedPlaceDoorWidths: [Float]?
    var selectedPlaceTableHights: [Float]?
    var selectedPlaceInformation = [String: Any]()
    
    var placesClient: GMSPlacesClient!
    
    var placesKeyDict = [String: String]()
    var placesDict = [String: String]()
    
    var basename: String
    
    private override init() {
        self.basename = "https://safe-spaces-224206.appspot.com/"
        super.init()
        
        self.placesClient = GMSPlacesClient.shared()
        self.getLikelyPlaces()
        self.getSearchData()
        self.selectedPlaceDoorWidths = [Float]()
        self.selectedPlaceTableHights = [Float]()
    }
    
    func getLikelyPlaces() {
        // Clean up from previous sessions.
        var likelyPlacesTemp: [GMSPlace] = []
        //likelyPlaces.removeAll()
        print("here")
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    likelyPlacesTemp.append(place)
                    //                    print(place)
                }
            }
            self.likelyPlaces = likelyPlacesTemp
        })
    }
    
    func getSearchData(){
        let fileURLProject = Bundle.main.path(forResource: "types", ofType: "csv")
        // Read from the file
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            var lines = readStringProject.components(separatedBy: .newlines)
            //sort through lines and add to dictionary
            lines = lines.filter(){$0 != ""}
            for line in lines {
                let typesArray = line.components(separatedBy: ",")
                let key: String = typesArray[0]
                let name: String = typesArray[1]
                placesDict[key] = name
                placesKeyDict[name] = key
                print("\(key) : \(name)")
                
            }
        } catch let error as NSError {
            print("Failed reading from URL: \(String(describing: fileURLProject)), Error: " + error.localizedDescription)
        }
    }
    
    func getLocation(googlePlaceID: String, completion: ((JSON) -> Void)?) {
        let postParams = ["google_place_id": googlePlaceID]
        
        Alamofire.request(self.basename + "location/get",
                          method: .post,
                          parameters: postParams,
                          headers: nil)
            .responseJSON { response in
                if (response.response?.statusCode == 200) {
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        do {
                            // Get json data
                            let json = try JSON(data: data)
                            
                            let returnVal = JSON(["location": json[0]["location"], "information": json[0]["information"]])
                            
                            completion?(returnVal)
                        } catch{
                            print("Unexpected error: \(error).")
                        }
                    }
                } else {
                    // Server error
                    print("SERVER ERROR GETTING LOCATION WITH GID: \(googlePlaceID)")
                }
        }
    }
    
    func addLocation(locationParams: [String: Any], completion: (([String: Any]) -> Void)?) {
        let postParams = ["location": locationParams]
        
        Alamofire.request(self.basename + "location/add_location",
                          method: .post,
                          parameters: postParams,
                          headers: nil)
            .responseJSON { response in
                if (response.response?.statusCode == 200) {
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        do {
                            // Get json data
                            let json = try JSON(data: data)
                            
                            let returnVal = ["location": json]
                            
                            completion?(returnVal)
                        } catch{
                            print("Unexpected error: \(error).")
                        }
                    } else {
                        // Server error
                        print("SERVER ERROR ADDING LOCATION")
                    }
                }
        }
    }
    
    func updateLocation(locationID: Int, locationParams: [String: Any], completion: (([String: Any]) -> Void)?) {
        var postParams = ["location": locationParams]
        postParams["location"]!["id"] = locationID
        
        Alamofire.request(self.basename + "location/update_location",
                          method: .post,
                          parameters: postParams,
                          headers: nil)
            .responseJSON { response in
                if (response.response?.statusCode == 200) {
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        do {
                            // Get json data
                            let json = try JSON(data: data)
                            
                            let returnVal = ["location": json]
                            
                            completion?(returnVal)
                        } catch{
                            print("Unexpected error: \(error).")
                        }
                    } else {
                        // Server error
                        print("SERVER ERROR UPDATING LOCATION")
                    }
                }
        }
    }
    
    func addInformation(informationParams: [String: Any], completion: (([String: Any]) -> Void)?) {
        let postParams = ["accessibility_information": informationParams]
        
        Alamofire.request(self.basename + "location/add_information",
                          method: .post,
                          parameters: postParams,
                          headers: nil)
            .responseJSON { response in
                if (response.response?.statusCode == 200) {
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        do {
                            // Get json data
                            let json = try JSON(data: data)
                            
                            let returnVal = ["information": json]
                            
                            completion?(returnVal)
                        } catch{
                            print("Unexpected error: \(error).")
                        }
                    } else {
                        // Server error
                        print("SERVER ERROR ADDING INFORMATION")
                    }
                }
        }
    }
    
    func updateInformation(informationID: Int, informationParams: [String: Any], completion: (([String: Any]) -> Void)?) {
        var postParams = ["accessibility_information": informationParams]
        postParams["accessibility_information"]!["id"] = informationID
        
        Alamofire.request(self.basename + "location/update_information",
                          method: .post,
                          parameters: postParams,
                          headers: nil)
            .responseJSON { response in
                if (response.response?.statusCode == 200) {
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        do {
                            // Get json data
                            let json = try JSON(data: data)
                            
                            let returnVal = ["information": json]
                            
                            completion?(returnVal)
                        } catch{
                            print("Unexpected error: \(error).")
                        }
                    } else {
                        // Server error
                        print("SERVER ERROR UPDATING LOCATION")
                    }
                }
        }
    }
}

