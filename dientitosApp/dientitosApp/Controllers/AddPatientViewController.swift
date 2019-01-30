//
//  AddPatientViewController.swift
//  dientitosApp
//
//  Created by Adrian on 1/21/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase
import Photos

class AddPatientViewController: UIViewController {

    var patients = [Patient]()
    
    @IBOutlet weak var namePatientTF: UITextField!
    @IBOutlet weak var agePatientTF: UITextField!
    @IBOutlet weak var phonePatientTF: UITextField!
    @IBOutlet weak var appointmentPatientTF: UITextField!
    @IBOutlet weak var treatmentPatientTF: UITextField!
    @IBOutlet weak var emailPatientTF: UITextField!
    
    @IBOutlet weak var patientimageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImagenView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Patient", style: .plain, target: self, action: #selector(addPatient))

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
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
    
    
    @objc func cancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPatient() {
        
        checkPermission()

        guard let email = emailPatientTF.text,
            email != "" else {
            AlertController.showAlert(inViewController: self, title: "Missing Email", message: "Please fill the emailbox")
                return
            }
        guard let age = agePatientTF.text,
            age != "" else {
            AlertController.showAlert(inViewController: self, title: "Missing Age", message: "Please fill the age box")
            return
            }
        guard let name = namePatientTF.text,
            name != "" else {
            AlertController.showAlert(inViewController: self, title: "Missing Name", message: "Please fill the name box")
            return
        }
        guard let phone = phonePatientTF.text,
            phone != "" else {
            AlertController.showAlert(inViewController: self, title: "Missing Phone", message: "Please fill the phone box")
            return
        }
        guard let appoinment = appointmentPatientTF.text,
            appoinment != "" else {
            AlertController.showAlert(inViewController: self, title: "Missing last name", message: "Please fill the name box")
            return
        }
        guard let treatment = treatmentPatientTF.text else {
            AlertController.showAlert(inViewController: self, title: "Missing Name", message: "Please fill the treatment box")
            return
        }
        
        
        let doctorUid = fetchUserLoggedIn()
        let patientID = name + age
        print(patientID)
        
        //Storage
        let imageName = NSUUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference().child("myPatients/\(imageName)")
        let  urlReference = storageRef
        if let uploadData = self.patientimageView.image!.jpegData(compressionQuality: 0.2) {
            storageRef.putData(uploadData, metadata: nil) { (metada, error) in
                
                if error != nil {
                    print(error ?? "error")
                    return
                }
                print(metada ?? "NO error")
                urlReference.downloadURL { url, error in
                    if let error = error {
                        print(error)
                    } else {
                        
                        if let profileImageURL = url?.absoluteString {
                            let values = ["name": name, "email": email, "phone": phone, "lastName": appoinment, "treatment": treatment, "age": age, "profilePatientURL": profileImageURL, "idDoctor": doctorUid, "idPatient": patientID]
                            
                            self.registerpatientIntoDBWithID(id: patientID, values: values)
                        }
                        print(url ?? "Tenemos la URL")
                    }
                    
                    
                    
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func registerpatientIntoDBWithID(id: String, values: [String: Any]) {
    //Referencia  la DB
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("myPatients").addDocument(data: values) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func profileImagenView() {

    patientimageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView)))
        patientimageView.isUserInteractionEnabled = true
        
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                
                print("success") }
        })
        default:
            print("")
        }
    }
    
}
