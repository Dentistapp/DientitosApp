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


class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Register"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerButton))
        
        delegateTextFields()
    }
    @objc func cancelButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func delegateTextFields() {
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getOut(action: UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func registerButton() {
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
            AlertController.showAlert(inViewController: self, title: "Cuenta creada", message: "Tu cuenta ah sido creada, inicia sesión con los datos que proporcionaste")
            
                
            })
            
            let alert = UIAlertController(title: "Account Created", message: "Your Account has been Created, log in with the data you provided", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: self.getOut))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    
}
