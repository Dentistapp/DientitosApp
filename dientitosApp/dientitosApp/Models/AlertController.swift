//
//  AlertController.swift
//  dientitosApp
//
//  Created by Adrian on 1/16/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit

class AlertController {
    static func showAlert(inViewController: UIViewController, title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
