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
import GooglePlacePicker
import SwiftyJSON

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var searchActive = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    
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
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
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
        }
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




// Handle the user's selection.
extension MapVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place Type: \(place.types[0])")
        print("Place address: \(place.formattedAddress!)")
        NetworkManager.sharedInstance.selectedPlace = place
        NetworkManager.sharedInstance.getLocation(googlePlaceID: place.placeID) { json in
            
            //print("LOCATION: \(json["location"]!)")
            //NetworkManager.sharedInstance.selectedPlaceInformation = json["information"]! as! [String : Any]
          
            var data = [String: Any]()
            
            for (key, object) in json {
                data[key] = object.stringValue
            }
            print(data)
            var info = data["information"]! as! String
            print("info",info)
            info.remove(at: info.startIndex)
            info.remove(at: info.endIndex);
            
            var responses = info.split(separator: "}")
            print("responses ", responses)
            
            let response = "\(responses[0])}"
            print("response ", response)
            let data2 = self.convertToDictionary(text: response)
            NetworkManager.sharedInstance.selectedPlaceInformation = data2 ?? [String: Any]()
            print(data2)
        }
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "viewReport") as! UINavigationController
        self.present(vc1, animated:true, completion: nil)
        
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
