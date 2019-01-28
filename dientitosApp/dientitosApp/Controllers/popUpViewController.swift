//
//  popUpViewController.swift
//  dientitosApp
//
//  Created by Adrian on 1/26/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {

    @IBOutlet weak var appoinmetnPickerDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Appoinment to (patient.name)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelVC))
    }
    @objc func cancelVC() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addPatientButtonPressed(_ sender: UIButton) {
    }
      
}
