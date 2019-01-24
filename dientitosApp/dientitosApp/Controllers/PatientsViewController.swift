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
        
        patientTableView.register(PatientCell.self, forCellReuseIdentifier: cellId)
        
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
                    let imageUrl = document.get("profilePatientURL") as! String
                    
                    let patient = Patient()
                    patient.name = nameFound
                    patient.email = emailFound
                    patient.profileImagenUrl = imageUrl
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PatientCell
        //we need to dequeue the cells for memory efficiency
        let patient = patients[indexPath.row]
        cell.textLabel?.text = patient.name
        cell.detailTextLabel?.text = patient.email

        
        if let profilePatientImageUrl = patient.profileImagenUrl {
            let url =  URL(string: profilePatientImageUrl)
            URLSession.shared.dataTask(with: url!) { (data, responde, error) in
                
                
                if error != nil {
                    print(error!)
                }
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
//                    cell.imageView?.image =
                }
            }.resume()
                
       
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
}


class PatientCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
         detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "addingNewPacient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return  imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        //x,y, width, height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
