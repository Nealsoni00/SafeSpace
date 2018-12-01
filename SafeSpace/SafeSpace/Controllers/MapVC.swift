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

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var searchActive = false
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.title = "Search for Accessible Locations"

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
        
//        searchBar.returnKeyType = .search
//        searchBar.enablesReturnKeyAutomatically = false
//        searchBar.delegate = self
        self.configureSearchBar()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func configureSearchBar(){
        self.modernSearchBar.delegateModernSearchBar = self as? ModernSearchBarDelegate
        var suggestionList = Array<String>()
        
        for type in NetworkManager.sharedInstance.placesKeyDict.keys{
            suggestionList.append("\(type)")
        }
        self.modernSearchBar.setDatas(datas: suggestionList)
        
    }
    
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
    }
    
    ///Called if you use Custom Item suggestion list
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        print("User touched this item: "+item.title+" with this url: "+item.url.description)
    }
    
    ///Called when user touched shadowView
    func onClickShadowView(shadowView: UIView) {
        print("User touched shadowView")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change, what i'm suppose to do ?")
    }
    
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
//    {
//        print("here")
//        self.searchBar.resignFirstResponder()
//        self.searchActive = false;
//        self.searchBar.endEditing(true)
//    }
//
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
        self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
//        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//        let region: MKCoordinateRegion = MKCoordinateRegion(center: currLocation!.coordinate, span: span)
//        
//        self.mapView.setRegion(region, animated: false)
        
        self.trackingUserLocation = true
        if (sender != nil) {
            sender?.isSelected = true
            sender!.popButton()
        }
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currLocation = userLocation
        NetworkManager.sharedInstance.getLikelyPlaces()
        if (isfirstUpdate){
            self.isfirstUpdate = false
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: false)
//            listLikelyPlaces()
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
        if segue.identifier == "add" {
            
            if let navController = segue.destination as? UINavigationController {
                
                if let childVC = navController.topViewController as? PlacesViewController {
                    childVC.likelyPlaces = likelyPlaces
                    
                }
                
            }
        }
    }
    
    
   
 
}




