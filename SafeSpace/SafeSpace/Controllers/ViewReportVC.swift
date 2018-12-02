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
    
    @IBOutlet weak var progressImage: UIImage!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
//        informationCell.isHidden = true
//        measurmentsCell.isHidden = true
//        measurmentsCell2.isHidden = true
//        measurmentsCell3.isHidden = true
        selectedPlace = NetworkManager.sharedInstance.selectedPlace
        
        self.loadingImage.startAnimating()
        self.loadingImage.isHidden = false
        
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
            messageLabel.text = "There is no accessibility information for \(selectedPlace?.name). Please consider contributing below:"
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
            newClassButton.addTarget(self, action: #selector(MeasurementsVC.addMeasurment), for: .touchUpInside)
            
            
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
    @objc func addMeasurment(){
//        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "addARMeasurment") as! UINavigationController
//        if let childVC = vc1.topViewController as? MeasureVC {
//            childVC.type = self.type!
//
//        }
//        self.present(vc1, animated:true, completion: nil)
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
    }
    @IBAction func addPressed(_ sender: AnyObject) {
        
        
    }

}
