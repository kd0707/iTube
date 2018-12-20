//
//  Validation.swift
//  POPAndMVCExercise
//
//  Created by Kamaluddin Khan on 24/10/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation

extension String{
    var isEmail: Bool{
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumber : Bool {
        let phoneNumberPattern = "[0-9]{10,10}"
        let phoneNumberTest = NSPredicate(format:"SELF MATCHES %@", phoneNumberPattern)
        return phoneNumberTest.evaluate(with : self)
    }
    
    var isNumber : Bool {
        let NumberPattern = "[0-9]{1,5}"
        let NumberTest = NSPredicate(format:"SELF MATCHES %@", NumberPattern)
        return NumberTest.evaluate(with : self)
    }
}
