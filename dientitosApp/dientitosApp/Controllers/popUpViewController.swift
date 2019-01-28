//
//  popUpViewController.swift
//  dientitosApp
//
//  Created by Adrian on 1/26/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase

class popUpViewController: UIViewController {
    
    var patient: Patient?
    
    //instanciar el VC anterior a este let 
    
    //pasarle el paciente actual para que tenga el uid
    //agregar campos de dia y hora y  obtener el uid del doctor loggeado
    @IBOutlet weak var nameLabel: UILabel!
    
    

    @IBOutlet weak var appoinmetnPickerDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        tryLabel()
        let name = patient?.name!
        navigationItem.title = "\(name)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addAppoinment))
    }
    
    @objc func addAppoinment() {
        
        //Appointmnet es prueba
        let appoinmentDay = "15 de febrero"
        let doctorUid = fetchUserLoggedIn()
        let patienID = "1235"
       // let a = 23
        let appoinmentHour = "22"
        
        let values =  ["appoinmentDay": appoinmentDay, "appoinmentHour": appoinmentHour, "doctorUid": doctorUid]
        
        self.registerAppoinmnetwithId(idPatient: patienID, doctorUID: doctorUid, values: values)
        
    }
    
    private func registerAppoinmnetwithId(idPatient: String, doctorUID: String, values: [String: Any]){
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        
        
        db.collection("Citas").addDocument(data: values) { err in
            if let err = err {
                print("Error writing document: \(err)")
                //Meter alerta de error
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @objc func cancelVC() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addPatientButtonPressed(_ sender: UIButton) {
    }
    
    func fetchPatientID(){
        
    }
    
    func fetchUserLoggedIn() -> String {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            return uid;
        }
        let error = "no encontre uid"
        return error
    }
    
    func tryLabel() {
        nameLabel.text = patient?.name
    }
      
}
