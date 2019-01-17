//
//  RegisterViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/10/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //Actions
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        guard let username = nameTextField.text,
            username != "" else {
                AlertController.showAlert(inViewController: self, title: "Missing Name", message: "Please fill the name box")
                print("You miss name")
            return
        }
        guard let email = emailTextField.text,
            email != "" else {
                AlertController.showAlert(inViewController: self, title: "Missing Email", message: "Please fill the email box")
                print("You miss email")
                return
        }
        guard let password = passwordTextField.text,
            password != "" else {
                AlertController.showAlert(inViewController: self, title: "Missing Password", message: "Please fill the password box")
                print("You miss password")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else {
                AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
                return
            }
            
            guard let user = user else { return }
            print(user.user.email ?? "Missing Email")
            print(user.user.uid)
            
            let changeRequest = user.user.createProfileChangeRequest()
            changeRequest.displayName = username
            
            changeRequest.commitChanges(completion: { (error) in
                guard error == nil else {
                    AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
                    return
                }
                
               // self.performSegue(withIdentifier: "signInSegue", sender: nil)
            AlertController.showAlert(inViewController: self, title: "Cuenta creada", message: "Tu cuenta ah sido creada, inicia sesión con los datos que proporcionaste")

            })
            self.performSegue(withIdentifier: "returnToLoginView", sender: nil)

            
            //Aqui podemos cambiar la foto del usuario
        }
        
    }
    

    
}
