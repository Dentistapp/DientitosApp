//
//  LoginViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/10/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var buttonFacebook: UIButton!

    
    //Progress animation
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ()
        setupViews()

    }
    
    
    
    
    
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        //Login with Email and password with Firebase
        guard let email = emailTextField.text,
            email != "" else {
                AlertController.showAlert(inViewController: self, title: "Missing email", message: "Please fill the email box")
                return
        }
        guard let password = passwordTextField.text,
            password != "" else {
                AlertController.showAlert(inViewController: self, title: "Missing password", message: "Please fill the password box")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
    }

    @objc func facebookButtonAction(sender: UIButton!) {
        print("Facebook login")
        hud.textLabel.text = "Logging in with Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.signIntoFirebase()
            case .failed(let error):
                print(error)
            case .cancelled:
                print("Canceled")
                self.hud.textLabel.text = "Canceled"
                self.hud.dismiss(afterDelay: 1, animated: true)
            }
        }
    }
    
    
    fileprivate func signIntoFirebase(){
        guard let  authenticationToken = AccessToken.current?.authenticationToken else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print (error)
                return
            }
            self.hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "SignInSegue", sender: nil)

        }
    }
    
    

    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
   
    //MARK: Setup Button Facebook
    
    fileprivate func setupViews(){
        
        buttonFacebook.backgroundColor = UIColor(named: "facebook")
        buttonFacebook.setImage(UIImage(named: "facebookLogo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonFacebook.setTitle("Sign in with Facebook", for: .normal)
        buttonFacebook.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonFacebook.setTitleColor(UIColor.white, for:.normal)
        buttonFacebook.addTarget(self, action: #selector(facebookButtonAction), for: .touchUpInside)
        self.view.addSubview(buttonFacebook)
        
    }
    
    
}
