//
//  locationCell.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import Foundation

import UIKit

class locationCell: UITableViewCell {
    
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var sportImage: UIImageView!
    
    
    @IBOutlet weak var SchoolInitial: UILabel!
    @IBOutlet weak var schoolView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
