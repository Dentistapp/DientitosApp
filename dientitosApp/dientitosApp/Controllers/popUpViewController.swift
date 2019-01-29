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
    
    private var datePicker: UIDatePicker?
    private var hourPicker: UIDatePicker?
    
    //instanciar el VC anterior a este let 
    
    //pasarle el paciente actual para que tenga el uid
    //agregar campos de dia y hora y  obtener el uid del doctor loggeado
    
    @IBOutlet weak var inputTextiel: UITextField!
    
    @IBOutlet weak var inputoHourTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(popUpViewController.dateChange(datePicker:)), for: .valueChanged)
        
        hourPicker = UIDatePicker()
        hourPicker?.datePickerMode = .time
        hourPicker?.addTarget(self, action: #selector(popUpViewController.hourChanged(datePicker: )), for: .valueChanged)
        
        inputTextiel.inputView = datePicker
        inputoHourTF.inputView = hourPicker
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popUpViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        let name = patient?.name!
        navigationItem.title = "Appoinment to \(name!)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addAppoinment))
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func hourChanged(datePicker: UIDatePicker) -> String {
        let hourFormatter = DateFormatter()
        hourFormatter.timeStyle = .short
        
        inputoHourTF.text = hourFormatter.string(from: hourPicker!.date)
        
        let hourString = hourFormatter.string(from: hourPicker!.date)
        view.endEditing(true)
        return hourString
    }
    
    @objc func dateChange(datePicker: UIDatePicker) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        print(dateFormatter)
        
        inputTextiel.text = dateFormatter.string(from:datePicker.date)
        
        let dateString = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        return dateString
    }
    
    @objc func addAppoinment() {
        
        //Appointmnet es prueba
        let appoinmentDay = dateChange(datePicker: datePicker!)
        let doctorUid = fetchUserLoggedIn()
        let patienID = patient?.uid
       // let a = 23
        let appoinmentHour = hourChanged(datePicker: hourPicker!)
        
        let values =  ["appoinmentDay": appoinmentDay, "appoinmentHour": appoinmentHour, "doctorUid": doctorUid]
        
        self.registerAppoinmnetwithId(idPatient: patienID!, doctorUID: doctorUid, values: values)
        
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
    

      
}
