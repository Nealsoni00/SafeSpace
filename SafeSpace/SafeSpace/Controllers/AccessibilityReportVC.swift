//
//  AccessibilityReportVC.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import GooglePlaces

class AccessibilityReportVC: UITableViewController {

    var selectedPlace: GMSPlace?
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    
    
    @IBOutlet var accessabilityReports: [UISegmentedControl]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (NetworkManager.sharedInstance.selectedPlace == nil){
            NetworkManager.sharedInstance.selectedPlace = NetworkManager.sharedInstance.likelyPlaces[0];
        }
        selectedPlace = NetworkManager.sharedInstance.selectedPlace
        self.loadingImage.startAnimating()
        self.loadingImage.isHidden = false
        
        self.loadFirstPhotoForPlace(placeID: selectedPlace!.placeID)
        self.locationName.text = selectedPlace?.name
        self.locationAddress.text = selectedPlace!.formattedAddress
        
        
        for segment in accessabilityReports{
            segment.selectedSegmentIndex = 0
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        if (NetworkManager.sharedInstance.selectedPlace == nil){
            NetworkManager.sharedInstance.selectedPlace = NetworkManager.sharedInstance.likelyPlaces[0];
           
           
        }
        selectedPlace = NetworkManager.sharedInstance.selectedPlace
        self.loadingImage.startAnimating()
        self.loadingImage.isHidden = false
        
        self.loadFirstPhotoForPlace(placeID: selectedPlace!.placeID)
        self.locationName.text = selectedPlace?.name
        self.locationAddress.text = selectedPlace!.formattedAddress
        
        print("appeared")
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.locationImage.image = photo;
                self.loadingImage.stopAnimating()
                self.loadingImage.isHidden = true
//                print(photoMetadata.attributions);
                //                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectLocation" {
            if let nextViewController = segue.destination as? MapVC {
                nextViewController.selectedPlace = selectedPlace
            }
        }
    }

}
