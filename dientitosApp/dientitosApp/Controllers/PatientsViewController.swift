//
//  PatientsViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/17/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase

class PatientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var patients = [Patient]()
    let cellId = "cellId"
    
    
    @IBOutlet weak var patientTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Patiens"
        //vcP.fetchUser()
        realodTable()
        fetchUser()
        
    }
    
    func realodTable() {
        DispatchQueue.main.async {
            self.patientTableView.reloadData()
        }
    }
    
    func fetchUser() {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("myPatients").getDocuments() { (querySnapshot, err) in
            
            //let patient = Patient()
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let nameFound = document.get("name") as! String
                    let emailFound = document.get("email") as! String
                    
                    let patient = Patient()
                    patient.name = nameFound
                    patient.email = emailFound
                    // print("User Found")
                    //  print("\(document.documentID) => \(document.data())")
                    print(patient.name!, patient.email ?? "not found")
                    
                    // print("qweqw")
                    //print(name, email)
                    print("yes")
                    //self.patients.append(patient)
                    self.patients.append(patient)
                    DispatchQueue.main.async {
                    self.patientTableView.reloadData()
                    }
                }
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        //we need to dequeue the cells for memory efficiency
        let patient = patients[indexPath.row]
        cell.textLabel?.text = patient.name
        cell.detailTextLabel?.text = patient.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

}
