//
//  UIViewExtension.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/1/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    func popButton() {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.7, options: [], animations: { () -> Void in
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5);
            
        }, completion: { (success: Bool) -> Void in
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.7, options: [], animations: { () -> Void in
                self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1);
            }, completion: { (success: Bool) -> Void in
                self.setImage(self.imageView?.image?.imageWithColor(UIColor(red:0.09, green:0.6, blue:1.0, alpha:1.0)
                    ), for: .selected)
            })
            
            
        })
    }
    
    
}

