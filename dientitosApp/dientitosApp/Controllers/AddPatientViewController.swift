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
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPatientButtonPressed(_ sender: UIButton) {
        
        checkPermission()
        
        guard let email = emailPatientTF.text,
            let age = agePatientTF.text,
            let name = namePatientTF.text,
            let phone = phonePatientTF.text,
            let appointment = appointmentPatientTF.text,
            let treatment = treatmentPatientTF.text else {
                print("Form is not valid")
                return
        }
        let patientID = name + age
        print(patientID)
        
                //Storage
                let imageName = NSUUID().uuidString
                let storage = Storage.storage()
                let storageRef = storage.reference().child("myPatients/\(imageName)")
                let  urlReference = storageRef
                if let uploadData = self.patientimageView.image!.pngData() {
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
                                    let values = ["name": name, "email": email, "phone": phone, "appoinment": appointment, "treatment": treatment, "age": age, "profilePatientURL": profileImageURL]
                                    
                                    self.registerpatientIntoDBWithID(id: patientID, values: values)
                                }
                                
                                print(url ?? "Tenemos la URL")
                                //Aqui tenemos el url
                            } 
                        
                        
                        
                    }
                }
                // Fetch the download URL

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
                   // let url = document.get("profilePatientURL")
                    
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
            print("No se que esta pasando")
        }
    }
    
    
}
