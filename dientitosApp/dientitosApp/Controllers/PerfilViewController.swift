//
//  PerfilViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/17/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase

class PerfilViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

    }
    
    // MARK: - Custom Sign Out Button
    
    let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleSignOutButtonTapped))
    
    
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
    }

    
}
