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
    
    func getOut(action: UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addAppoinment() {
        let appoinmentDay = dateChange(datePicker: datePicker!)
        let doctorUid = fetchUserLoggedIn()
        let patienID = patient?.uid!
        let appoinmentHour = hourChanged(datePicker: hourPicker!)
        
        let values =  ["appoinmentDay": appoinmentDay, "appoinmentHour": appoinmentHour, "doctorUid": doctorUid, "idPatient": patienID] 
        
        self.registerAppoinmnetwithId(doctorUID: doctorUid, values: values as [String : Any])
        
        let alert = UIAlertController(title: "Appoinment Created", message: "Your Appoinment has been created", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    private func registerAppoinmnetwithId( doctorUID: String, values: [String: Any]){
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
    
    
    func fetchUserLoggedIn() -> String {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            return uid;
        }
        let error = "no encontre uid"
        return error
    }
    func fetchDocumentIdPerPatient() {
            let db = Firestore.firestore()
            let settings = db.settings
            settings.areTimestampsInSnapshotsEnabled = true
            db.settings = settings
            
            db.collection("myPatients").getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let patientId = document.get("uid") as! String
                        self.patient!.uid = patientId
                        }
                    }
            }
    }
    

}
