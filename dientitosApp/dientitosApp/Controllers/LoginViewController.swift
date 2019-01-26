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
    
    
    //Progress
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        //Login with Email and password with Firebase
        guard let email = emailTextField.text,
            email != "" else {
                AlertController.showAlert(inViewController: self, title: "Missing email", message: "Please fill the email box")
                print("You miss email")
                return
        }
        guard let password = passwordTextField.text,
            password != "" else {
                AlertController.showAlert(inViewController: self, title: "Missing password", message: "Please fill the password box")
                print("You miss name")
                return
        }
        hud.textLabel.text = "Sign In..."
        hud.show(in: view, animated: true)
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
                return
            }
            guard let user = user else { return }
                print(user.user.email ?? "MISSING EMAIL")
                print(user.user.displayName ?? "MISSING DISPLAY NAME")
                print(user.user.uid)
            
            
            self.performSegue(withIdentifier: "SignInSegue", sender: nil)
            
        }
        
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @objc func facebookButtonAction(sender: UIButton!) {
        print("Facebook login")
        hud.textLabel.text = "Logging in with Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Succesfully logged in Facebook")
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
            print("Succesfully authenticated with Firebase")
            self.hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "SignInSegue", sender: nil)

        }
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
//    button.setTitle("Login With Facebook", for: .normal)
//    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
//    button.setTitleColor(Service.buttonTitleColor, for: .normal)
//    button.backgroundColor = Service.buttonBackgroundColorSignWithFacebook
//    button.layer.masksToBounds = true
//    button.layer.cornerRadius = Service.buttonCornerRadius
//    button.setImage(UIImage(named: "facebookLogo")?.withRenderingMode(.alwaysOriginal), for: .normal)
//    button.contentMode = .scaleAspectFit
    
    
    
}
