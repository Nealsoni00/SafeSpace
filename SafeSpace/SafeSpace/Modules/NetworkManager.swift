//
//  dataStore.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import Foundation
import GooglePlaces

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var selectedPlaceDoorWidths: [Float]?
    var selectedPlaceTableHights: [Float]?
    
    var placesClient: GMSPlacesClient!

    var placesKeyDict = [String: String]()
    var placesDict = [String: String]()
    
    
    
    private override init() {
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
    
    
    

}
