//
//  ViewReportVC.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/2/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewReportVC: UITableViewController {
    
    @IBOutlet weak var progressImage: UIImageView!
    
    @IBOutlet weak var informationCell: UITableViewCell!
    
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var measurmentsCell: UITableViewCell!
    @IBOutlet weak var measurmentsCell2: UITableViewCell!
    @IBOutlet weak var measurmentsCell3: UITableViewCell!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationName: UILabel!
    var selectedPlace: GMSPlace?
    
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    var noData: Bool = false;
    @IBOutlet var segmentedCollection: [UISegmentedControl]!
    
    override func viewDidLoad() {
        print(NetworkManager.sharedInstance.selectedPlaceInformation)
        super.viewDidLoad()
//        informationCell.isHidden = true
//        measurmentsCell.isHidden = true
//        measurmentsCell2.isHidden = true
//        measurmentsCell3.isHidden = true
        selectedPlace = NetworkManager.sharedInstance.selectedPlace
        
        self.loadingImage.startAnimating()
        self.loadingImage.isHidden = false
        self.populate()
        self.loadFirstPhotoForPlace(placeID: selectedPlace!.placeID)
        self.locationName.text = selectedPlace?.name
        self.locationAddress.text = selectedPlace!.formattedAddress
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    var isSecondTime = false;
    func populate(){
        informationCell.isHidden = true
        measurmentsCell.isHidden = true
        measurmentsCell2.isHidden = true
        measurmentsCell3.isHidden = true
        progressImage.isHidden = true
        noData = true;
        let data = NetworkManager.sharedInstance.selectedPlaceInformation
        if (isSecondTime){
            informationCell.isHidden = true
            measurmentsCell.isHidden = true
            measurmentsCell2.isHidden = true
            measurmentsCell3.isHidden = true
            progressImage.isHidden = true
            noData = true;
            self.tableView.reloadData()
        }
        isSecondTime = true;
        if data["gen_accessible"] == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.populate()
            })
            print("the table is empty!!!")
        }else{
            informationCell.isHidden = false
            measurmentsCell.isHidden = false
            measurmentsCell2.isHidden = false
            measurmentsCell3.isHidden = false
            progressImage.isHidden = false
            noData = false;
            self.segmentedCollection[0].selectedSegmentIndex = self.flip(val: data["gen_accessible"] as! Int)
            self.segmentedCollection[1].selectedSegmentIndex = self.flip(val: (data["ramps"] as? Int == nil) ? 3 : data["ramps"] as! Int)
            self.segmentedCollection[2].selectedSegmentIndex = self.flip(val: (data["elevators"] as? Int == nil) ? 3 : data["elevators"] as! Int)
            self.segmentedCollection[3].selectedSegmentIndex = self.flip(val: (data["smooth"] as? Int == nil) ? 3 : data["smooth"] as! Int)
            self.segmentedCollection[4].selectedSegmentIndex = self.flip(val: (data["parking"] as? Int == nil) ? 3 : data["parking"] as! Int)
            self.segmentedCollection[5].selectedSegmentIndex =  self.flip(val: (data["bathrooms"] as? Int == nil) ? 3 : data["bathrooms"] as! Int)
            self.segmentedCollection[6].selectedSegmentIndex = self.flip(val: (data["sight_impaired"] as? Int == nil) ? 3 : data["sight_impaired"] as! Int)
            self.segmentedCollection[7].selectedSegmentIndex = self.flip(val: (data["sound"] as? Int == nil) ? 3 : data["sound"] as! Int)
            let score = Int(Float((data["score"]! as! NSNumber)) * 100)
            print("score ", score);
            print("score2 ", data["score"]!)
            self.progressImage.image = UIImage(named: "sunroofControl\(score).png")
        }
        self.tableView.reloadData()
        
    }
    
    func flip(val: Int) -> Int{
        if (val == 0){
            return 1
        }else if (val == 1){
            return 0
        }else{
            return 0
        }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (noData){
            // Display a message when the table is empty
            let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
            
            let sportsIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: newView.center.y - 150, width: 100, height: 100))
            sportsIcon.image = UIImage(named: "logo.png")
            sportsIcon.center.x = newView.center.x
            
            let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: newView.center.y - 20, width: newView.frame.width - 20, height: 50))
            messageLabel.text = "There is no accessibility information for \(selectedPlace!.name). Please consider contributing below:"
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.center.x = newView.center.x
            messageLabel.font = UIFont(name: "Robot-Regular", size: 20)
            
            let newClassButton: UIButton = UIButton(frame: CGRect(x: 0, y: newView.center.y + 50, width: 200, height: 50))
            newClassButton.backgroundColor = UIColor.purple
            newClassButton.center.x = newView.center.x
            newClassButton.setTitle("Contribute", for: UIControl.State())
            newClassButton.titleLabel?.textAlignment = .center
            newClassButton.titleLabel?.font = UIFont(name: "Robot-Regular", size: 25)
            newClassButton.addTarget(self, action: #selector(ViewReportVC.contribute), for: .touchUpInside)
            
            
            newView.addSubview(sportsIcon)
            newView.addSubview(messageLabel)
            newView.addSubview(newClassButton)
            
            
            self.tableView.backgroundView = newView
            self.tableView.separatorStyle = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            return 0
            
        }else{
            self.tableView.backgroundView = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return 2
    }
    @objc func contribute(){
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "form") as! UINavigationController
        if let childVC = vc1.topViewController as? AccessibilityReportVC {
            self.present(vc1, animated:true, completion: nil)
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
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
//        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
////        if let childVC = vc1.topViewController as? AccessibilityReportVC {
//            self.present(vc1, animated:true, completion: nil)
////        }
        
    }
    @IBAction func addPressed(_ sender: AnyObject) {
        
        
    }

}
