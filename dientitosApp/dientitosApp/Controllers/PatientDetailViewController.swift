//
//  PatientDetailViewController.swift
//  dientitosApp
//
//  Created by Adrian on 1/24/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit

class PatientDetailViewController: UIViewController {
    
    @IBOutlet weak var imagePatient: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var treatmentlabel: UILabel!
    @IBOutlet weak var appoinmentLabel: UILabel!
    
    var image = UIImage()
    var name = ""
    var patient: Patient?
    //var name : String

    override func viewDidLoad() {
        super.viewDidLoad()

       imagePatient.image = image
        //appoinmentLabel.text = "Que esta pasando aqui \(appointment)"
        patientNameLabel.text? = "\(name)"
        
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
