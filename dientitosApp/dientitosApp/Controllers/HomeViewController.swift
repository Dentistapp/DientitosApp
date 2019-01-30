//
//  HomeViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/10/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {

    
    //Ouletss
    @IBOutlet weak var testLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       guard let username =  Auth.auth().currentUser?.displayName else { return }
        testLabel.text = "Hello \(username)"

        
        


    }

   
}
