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

     let viewC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Custom Sign Out Button
    
    let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleSignOutButtonTapped))
    
    
    @objc func handleSignOutButtonTapped(_ sender: Any){
        
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("Salimooos")
                self.present(viewC, animated: true, completion: nil)
                
            }
            catch {
            }
        }
        
        
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
   

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
