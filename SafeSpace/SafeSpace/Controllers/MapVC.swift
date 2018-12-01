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


class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
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
        
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func locateMe(sender: UIBarButtonItem) {
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("here");
        let userLocation:CLLocation = locations[0] as CLLocation
        
//        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        mapView.setRegion(region, animated: true)
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
//
//        self.labelLat.text = "\(userLocation.coordinate.latitude)"
//        self.labelLongi.text = "\(userLocation.coordinate.longitude)"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
//                self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
 
}

