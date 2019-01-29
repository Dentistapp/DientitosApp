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

    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var patientPhoneLabel: UILabel!
    @IBOutlet weak var patientEmailLabel: UILabel!
    var image = UIImage()
    var name = ""
    var patient: Patient?
    
    //var name : String

    override func viewDidLoad() {
        super.viewDidLoad()
        patientDetail()

        //appoinmentLabel.text = "Que esta pasando aqui \(appointment)"
        
    }
    
   
    func patientDetail(){
        patientNameLabel.text = patient?.name
        ageLabel.text = patient?.age
        patientPhoneLabel.text = patient?.phone
        patientEmailLabel.text = patient?.email

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? popUpViewController
        let patient = sender as? Patient
        destVC?.patient = sender  as? Patient
        print(patient!)
        
    }
    
    func saveInfo() {
        let patientToSend = patient
        performSegue(withIdentifier: "appoinmentSegue", sender: patientToSend)
    }

    @IBAction func popUpVCButtonPressed(_ sender: UIButton) {
        saveInfo()
    }

    
}
