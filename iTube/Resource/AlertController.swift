//
//  AlertController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 15/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import UIKit
class Alert{
    
    static func showAlertMessage(vc:UIViewController, title:String, message:String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
}
