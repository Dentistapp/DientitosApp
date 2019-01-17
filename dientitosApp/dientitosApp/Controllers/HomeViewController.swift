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
        
        


        // Do any additional setup after loading the view.
    }
    
    
    //Actions

    
    //Boton para terminar la sesion actual
    @IBAction func signOutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            //MARK Encontrar la forma de volver a la pantalla de login sin usar segue. para que no se aniden las vistas.
            performSegue(withIdentifier: "loginViewSegue", sender: nil)
        } catch {
            print(error)
        }
    }
}
