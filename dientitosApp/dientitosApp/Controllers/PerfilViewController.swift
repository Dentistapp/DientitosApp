//
//  PerfilViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/17/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class PerfilViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailButton: UIButton!
   
    @IBOutlet weak var emailLabel: UILabel!
    
    let userName = Auth.auth().currentUser?.displayName
    let userEmail = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        nameLabel.text = userName
        emailLabel.text = userEmail
        
    }
    
    // MARK: - Custom Sign Out Button
    
    let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleSignOutButtonTapped))
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        let mailComposerViewController = configureMail()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposerViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
   
    
    @objc func handleSignOutButtonTapped(_ sender: Any){
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "unwindToLoginVC", sender: nil)
            } catch let error {
                AlertController.showAlert(on: self, preferredStyle: .alert, title: "Sign out error", message: error.localizedDescription)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertController.showAlert(on: self, preferredStyle: .actionSheet, title: nil, message: nil, actions: [signOutAction,cancelAction], completion: nil)
    }
    

    lazy var navBar: UINavigationBar = {
        let navBar: UINavigationBar = UINavigationBar(frame: .zero)
        let navItem = UINavigationItem(title: "Perfil")
        navItem.rightBarButtonItem = signOutButton
        navBar.setItems([navItem], animated: false)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    func setupNavBar() {
        view.backgroundColor = .white
        self.view.addSubview(navBar)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        
        emailButton.setTitle("Send Email ", for: .normal)
        emailButton.backgroundColor = UIColor(named: "Color")
        emailButton.layer.cornerRadius = 10
        
        
    }

    
}

extension PerfilViewController: MFMailComposeViewControllerDelegate{
    
    func configureMail() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["test@test.com"])
       // mailComposerVC.setToRecipients(["\(String(describing: userEmail))"])
        mailComposerVC.setSubject("Treatment Recommendations")
        mailComposerVC.setMessageBody("This is a test", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError()  {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your divice could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert,animated: true, completion: nil )
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
