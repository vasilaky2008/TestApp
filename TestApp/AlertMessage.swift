//
//  AlertMessage.swift
//  TestApp
//
//  Created by NotyTeam Group on 03.06.2020.
//  Copyright © 2020 Vasiliy Safta. All rights reserved.
//

import Foundation
import UIKit

class AlertMessage {
    
    static let sharedAlert = AlertMessage()
    
    func showAlert(title:String?, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(ok)
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
        }
    }
    
    private init() { }
    
}
