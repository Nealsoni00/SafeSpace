//
//  AccessibilityReportVC.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import GooglePlaces
import PopupDialog

class AccessibilityReportVC: UITableViewController {

    var selectedPlace: GMSPlace?
    var doorWidths: [Float]?
    var tableHeights: [Float]?
    
    @IBOutlet weak var tableHeightsLabel: UILabel!
    @IBOutlet weak var doorWidthsLabel: UILabel!
    
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
        doorWidths = NetworkManager.sharedInstance.selectedPlaceDoorWidths
        tableHeights = NetworkManager.sharedInstance.selectedPlaceTableHights
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent

        updateLabels()

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
        doorWidths = NetworkManager.sharedInstance.selectedPlaceDoorWidths
        tableHeights = NetworkManager.sharedInstance.selectedPlaceTableHights
        
        updateLabels()
        print("appeared")
    }
    func updateLabels(){
        if (doorWidths?.count ?? 0 != 0){
            print("there are \(doorWidths?.count) doors")
            var sum: Float = 0.00
            for door in doorWidths!{
                sum += door
            }
            let average = sum/Float(doorWidths!.count)
            doorWidthsLabel.text = "Average Door Width: \(average) in"
        }else{
            doorWidthsLabel.text = "Measure Location's Door Widths"
        }
        if (tableHeights?.count ?? 0 != 0){
            var sum: Float = 0.00
            for door in tableHeights!{
                sum += door
            }
            let average = sum/Float(tableHeights!.count)
            
            tableHeightsLabel.text = "Average Table Height: \(average) in"
        }else{
            doorWidthsLabel.text = "Measure Location's Table Heights"
        }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("HERE")
        let indexPath = tableView.indexPathForSelectedRow // index path of selected cell
        
        
        if indexPath!.section == 2 {
            switch indexPath!.row {
            case 0:
                
                print("need to measure doors")
            case 1:
                print("need to measure tables")
                
            default:
                break
            }
        }else if indexPath!.section == 3 {
            switch indexPath!.row {
            case 0:
                self.submitform()
            default:
                break
            }
        }
        
        
    }
    func submitform(){
        print("here 1")
        var addressComps = selectedPlace!.formattedAddress!.split(separator: ",")
        let name = addressComps[0] ?? ""
        let address = addressComps[1] ?? ""
        let city = addressComps[2]
        let state = ""
//        let state = (addressComps[3]).split(separator: " ")[0] ?? " "
        let zip = ""
        let locationParams = ["location_type_name":selectedPlace!.types, "name":name, "address":address, "city":city, "state":state,  "lat":selectedPlace!.coordinate.latitude, "long":selectedPlace!.coordinate.longitude, "google_place_id":selectedPlace!.placeID] as [String : Any]
        NetworkManager.sharedInstance.addLocation(locationParams: locationParams) { json in
            print("ADD LOCATION RESPONSE: \(json)")
            var sum: Float = 0.0
            for accessible in self.accessabilityReports{
                if self.accessabilityReports[0].selectedSegmentIndex == 1 {
                    sum += 1.0
                }
            }
            var score: Float = sum/8
            let accessible = self.swapData(data: Int(self.accessabilityReports[0].selectedSegmentIndex))
            let ramps = self.swapData(data: Int(self.accessabilityReports[1].selectedSegmentIndex))
            let lifts = self.swapData(data: Int(self.accessabilityReports[2].selectedSegmentIndex))
            let surfaces = self.swapData(data: Int(self.accessabilityReports[3].selectedSegmentIndex))
            let parking = self.swapData(data: Int(self.accessabilityReports[4].selectedSegmentIndex))
            let bathrooms = self.swapData(data: Int(self.accessabilityReports[5].selectedSegmentIndex))
            let signs = self.swapData(data: Int(self.accessabilityReports[6].selectedSegmentIndex))
            let loud = self.swapData(data: Int(self.accessabilityReports[7].selectedSegmentIndex))
            print(accessible,ramps,lifts,surfaces,parking)
            print("here 3")
            print(self.selectedPlace!.placeID)
            let informationParams = ["google_place_id":self.selectedPlace!.placeID,"gen_accessible":accessible, "ramps":ramps,"smooth":surfaces,"parking":parking,"bathrooms":bathrooms,"sight_impaired":signs,"elevators":lifts, "sound":loud,"door_widths":self.doorWidths,"table_heights":self.tableHeights!, "score":score] as [String : Any]
            
            NetworkManager.sharedInstance.addInformation(informationParams: informationParams) { json in
                print("ADD INFO RESPONSE: \(json)")
            }
        }
         print("here 2")
      
        let popup = PopupDialog(title: "Thank you!", message: "We have successfully recorded your report! Thank you for helping Safe Space")
        
        popup.transitionStyle = .fadeIn
        let buttonOne = DefaultButton(title: "Dismiss") {
            self.performSegue(withIdentifier: "goHome", sender: self)
        }
        
        popup.addButton(buttonOne)
        // to add a single button
        popup.addButton(buttonOne)
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
         print("here 4")
        
//        print(accessabilityReports[0].selectedSegmentIndex == 0 ? "True" : "False")
        
    }
    func swapData(data: Int) -> Bool{
        print(data)
        if (data == 1){
            return false
        }else{
            return true
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectLocation" {
            if let nextViewController = segue.destination as? MapVC {
                nextViewController.selectedPlace = selectedPlace
            }
        }else if segue.identifier == "table" {
            if let navController = segue.destination as? UINavigationController {
                print("here TABLE PLEASE PLEASE PLEASE!")
                if let childVC = navController.topViewController as? MeasurementsVC {
                    print("table")
                    childVC.type = "table"
                    
                }
                
            }
            
            
        }else if segue.identifier == "doorMeasurments" {
            if let navController = segue.destination as? UINavigationController {
                print("here!")
                if let childVC = navController.topViewController as? MeasurementsVC {
                    childVC.type = "door"
                    
                }
                
            }
            
        }
     
    }
    @IBAction func dismiss(_ sender: Any) {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        ////        if let childVC = vc1.topViewController as? AccessibilityReportVC {
        //            self.present(vc1, animated:true, completion: nil)
        ////        }
        self.present(vc1, animated: true, completion: nil)
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
    
 

}
