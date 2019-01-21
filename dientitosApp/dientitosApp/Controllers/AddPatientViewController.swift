//
//  AddPatientViewController.swift
//  dientitosApp
//
//  Created by Adrian on 1/21/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase

class AddPatientViewController: UIViewController {

    var patients = [Patient]()
    
    @IBOutlet weak var namePatientTF: UITextField!
    @IBOutlet weak var agePatientTF: UITextField!
    @IBOutlet weak var phonePatientTF: UITextField!
    @IBOutlet weak var appointmentPatientTF: UITextField!
    @IBOutlet weak var treatmentPatientTF: UITextField!
    @IBOutlet weak var emailPatientTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPatientButtonPressed(_ sender: UIButton) {
        
        guard let email = emailPatientTF.text,
            let age = agePatientTF.text,
            let name = namePatientTF.text,
            let phone = phonePatientTF.text,
            let appointment = appointmentPatientTF.text,
            let treatment = treatmentPatientTF.text else {
                print("Form is not valid")
                return
        }
        
        let values = ["name": name, "email": email, "phone": phone, "appoinment": appointment, "treatment": treatment, "age": age]
        
        //Referencia  la DB
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("myPatients").addDocument(data: values) { err in
            if let err = err {
                print("Error writing document: \(err)")
                //Meter alerta de error
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func fetchUser() {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("myPatients").getDocuments() { (querySnapshot, err) in
            
            let patient = Patient()
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let name = document.get("name") as! String
                    let email = document.get("email") as! String
                    
                    print("User Found")
                    print("\(document.documentID) => \(document.data())")
                    
                    print("qweqw")
                    print(name, email)
                    print("yes")
                    self.patients.append(patient)
                }
            }
        }
    }
    
    
    
}
