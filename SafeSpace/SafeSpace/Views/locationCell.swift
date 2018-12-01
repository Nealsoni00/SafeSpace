//
//  locationCell.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import Foundation

import UIKit
import GooglePlaces

class locationCell: UITableViewCell {
    
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var buisnessImage: UIImageView!
    var currPlace: GMSPlace?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func initCell(){
        self.loading.startAnimating()
        self.loading.isHidden = false
        self.name.text = currPlace?.name ?? ""
        self.address.text = currPlace?.formattedAddress ?? ""
        loadFirstPhotoForPlace(placeID: currPlace?.placeID ?? "")
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
                self.buisnessImage.image = photo;
                self.loading.stopAnimating()
                self.loading.isHidden = true
                print(photoMetadata.attributions);
//                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
}
