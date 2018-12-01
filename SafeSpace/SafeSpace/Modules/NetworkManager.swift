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
    var placesClient: GMSPlacesClient!

    private override init() {
        super.init()
        self.placesClient = GMSPlacesClient.shared()
        self.getLikelyPlaces()
    }
    
    func getLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
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
                    self.likelyPlaces.append(place)
                    print(place)
                }
            }
        })
    }
    

}
