//
//  FirstViewController.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import GooglePlaces
import GoogleMaps

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var trackingUserLocation = true
    var isfirstUpdate = true
    @IBOutlet weak var myLocationButton: UIButton!
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    let selectionFeedback = UISelectionFeedbackGenerator()
    var currLocation: MKUserLocation?
    
    var placesClient: GMSPlacesClient!
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.mapType = .hybrid
        self.mapView.delegate = self
        self.mapView.isRotateEnabled = false
        self.mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.myLocationButton.isSelected = true;
        self.trackingUserLocation = true;
        self.placesClient = GMSPlacesClient.shared()
        
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (self.mapView.userTrackingMode != .follow) {
            print("set to not follow");
            self.trackingUserLocation = false
            self.myLocationButton.isSelected = false
        }
        
    }
    
    @IBAction func setMyLocation(_ sender: UIButton?) {
        self.selectionFeedback.selectionChanged()
        
        myLocationButton.isSelected = true;
        
    self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
//    self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: currLocation!.coordinate, span: span)
        
        self.mapView.setRegion(region, animated: false)
        
        self.trackingUserLocation = true
        if (sender != nil) {
            sender?.isSelected = true
            sender!.popButton()
        }
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currLocation = userLocation
        if (isfirstUpdate){
            self.isfirstUpdate = false
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: false)
            listLikelyPlaces()
        }
    }
    
    func listLikelyPlaces() {
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelect" {
            if let nextViewController = segue.destination as? PlacesViewController {
                nextViewController.likelyPlaces = likelyPlaces
            }
        }
    }
    
 
}




