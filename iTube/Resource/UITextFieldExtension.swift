//
//  CustomeTextField.swift
//  iTube
//
//  Created by Kamaluddin Khan on 14/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    
    func setBottomBorder(){
        let border = CALayer()
        let borderWidth = CGFloat(1)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: UIScreen.main.bounds.width-32, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
