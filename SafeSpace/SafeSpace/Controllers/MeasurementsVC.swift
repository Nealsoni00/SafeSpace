//
//  measurementsVC.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit



class MeasurementsVC: UITableViewController {
    
    @IBOutlet var table: UITableView!
    var type: String?
    
    var swipeMode = false
    var measurements: [Float]?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if (type == nil){
            type = "door"
        }
        print("we are of type \(type)")
        
        if (type! == "door"){
            self.measurements = NetworkManager.sharedInstance.selectedPlaceDoorWidths
        }else{
            self.measurements = NetworkManager.sharedInstance.selectedPlaceTableHights
        }
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationItem.title = "Door Measurments"
        
        //        print(self.defaultSports.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if ((measurements?.count ?? 0) < 1){
            // Display a message when the table is empty
            let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
            
            let sportsIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: newView.center.y - 150, width: 100, height: 100))
            sportsIcon.image = UIImage(named: "logo.png")
            sportsIcon.center.x = newView.center.x
            
            let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: newView.center.y - 20, width: newView.frame.width - 20, height: 50))
            messageLabel.text = "You have no measurments. To add a new measurment, please tap \"add\" below"
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.center.x = newView.center.x
            messageLabel.font = UIFont(name: "Robot-Regular", size: 20)
            
            let newClassButton: UIButton = UIButton(frame: CGRect(x: 0, y: newView.center.y + 50, width: 200, height: 50))
            newClassButton.backgroundColor = UIColor.purple
            newClassButton.center.x = newView.center.x
            newClassButton.setTitle("Add Measurment", for: UIControl.State())
            newClassButton.titleLabel?.textAlignment = .center
            newClassButton.titleLabel?.font = UIFont(name: "Robot-Regular", size: 25)
            newClassButton.addTarget(self, action: #selector(MeasurementsVC.addMeasurment), for: .touchUpInside)
            
            
            newView.addSubview(sportsIcon)
            newView.addSubview(messageLabel)
            newView.addSubview(newClassButton)
            
            
            self.tableView.backgroundView = newView
            self.tableView.separatorStyle = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
        }else{
            self.tableView.backgroundView = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return 1
    }
    @objc func addMeasurment(){
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "addARMeasurment") as! UINavigationController
        if let childVC = vc1.topViewController as? MeasureVC {
            childVC.type = self.type!
            
        }
        self.present(vc1, animated:true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return measurements?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurmentCell", for: indexPath) as! MeasurmentCell
        
        let current = measurements![indexPath.row]
        cell.distance.text = "\(current)"
        
//        let image: UIImage = UIImage(named: "\(current.replacingOccurrences(of: " ", with: "")).png") ?? UIImage()
//        print("SPORT NAME: \(current)")
//        cell.sportImage!.image = image.imageWithColor(newColor)
        return cell
    }
    
    @objc func skipView(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func add(_ sender: Any) {
        //prep for segur
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "addARMeasurment") as! UINavigationController
        if let childVC = vc1.topViewController as? MeasureVC {
            childVC.type = self.type!
            
        }
        self.present(vc1, animated:true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if self.isEditing == false {
            print("editing false")
            return .delete
        }
        else if self.isEditing && indexPath.row == (self.measurements!.count) {
            return .insert
        }
        else {
            return .delete
        }
    }
    
    var curSport: String?
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Here we define the buttons for the table cell swipe
        
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let certainMeasurment = self.measurements![indexPath.row]
            
            print("Delete \(certainMeasurment)")
            
            //Delete the class
            //Send the delete request to the server
            
            
            if let index = self.measurements!.index(of:certainMeasurment) {
                self.measurements!.remove(at: index)
               
                if (self.type! == "door"){
                    NetworkManager.sharedInstance.selectedPlaceDoorWidths = self.measurements
                }else{
                     NetworkManager.sharedInstance.selectedPlaceTableHights = self.measurements
                }
               
//                defaults.set(defaultSports, forKey: "allSports")
            }
            self.table.deleteRows(at: [indexPath], with: .automatic)
            if (self.isEditing == false) {
                self.setEditing(false, animated: true)
            }
            
            
            
            
            //Upon completion of the delete request reload the table
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    //These methods allows the swipes to occur
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .insert) {
            //            self.performSegue(withIdentifier: "periodSegue", sender: nil)
        }
    }
    
    func addClass() {
        if (self.isEditing == false) {
            self.setEditing(true, animated: false)
        }
        //        self.performSegue(withIdentifier: "periodSegue", sender: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        print("set editing \(editing)")
        super.setEditing(editing, animated: true)
        if (!self.swipeMode) {
            if (editing) {
                self.table.allowsSelectionDuringEditing = true
                if (self.measurements!.count != 0){
                    if (self.measurements!.count > 0) {
                        self.table.insertRows(at: [IndexPath(row: self.measurements!.count, section: 0)], with: .automatic)
                    }
                }
            }
            else {
                if (self.table.numberOfRows(inSection: 0) > self.measurements!.count) {
                    self.table.deleteRows(at: [IndexPath(row: self.measurements!.count, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.swipeMode = true
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.swipeMode = false
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
//        if sweetBlue.isLight(){
//            newColor = UIColor.black
//        }else{
//            newColor = sweetBlue
//        }
        if (type! == "door"){
            self.measurements = NetworkManager.sharedInstance.selectedPlaceDoorWidths
        }else{
            self.measurements = NetworkManager.sharedInstance.selectedPlaceTableHights
        }
//        print(self.measurements)
        table.reloadData()
        
    }
    
    
}
