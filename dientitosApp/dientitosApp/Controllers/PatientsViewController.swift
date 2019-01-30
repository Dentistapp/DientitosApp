//
//  PatientsViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/17/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase

class PatientsViewController: UIViewController {
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    var patients = [Patient]()
    let cellId = "cellId"
    var myIndex = 0
    let patientDetailVC = PatientDetailViewController()

    
    @IBOutlet weak var patientTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientTableView.refreshControl = refresher
        self.navigationItem.title = "Patiens"
        
        patientTableView.register(PatientCell.self, forCellReuseIdentifier: cellId)
        
        fetchUserDeletingOldsValues()
        
    }
    
    @objc func requestData() {
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.fetchUserDeletingOldsValues()
            self.refresher.endRefreshing()
        }
    }
    
    func fetchUserDeletingOldsValues() {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("myPatients").getDocuments() { (querySnapshot, err) in
            
            self.patients.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let nameFound = document.get("name") as! String
                    let emailFound = document.get("email") as! String
                    let imageUrl = document.get("profilePatientURL") as! String
                    let treatment = document.get("treatment") as! String
                    let age = document.get("age") as! String
                    let phone = document.get("phone") as! String
                    let appoinment = document.get("appoinment") as? String
                    let uid = document.get("idPatient") as! String
                    
                    let patient = Patient()
                    patient.name = nameFound
                    patient.email = emailFound
                    patient.profileImagenUrl = imageUrl
                    patient.treatment = treatment
                    patient.age = age
                    patient.phone = phone
                    patient.appointment = appoinment
                    patient.uid = uid
                    
                    self.patients.append(patient)
                    DispatchQueue.main.async {
                        self.patientTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let patieneDetailVC = segue.destination as? PatientDetailViewController
        let patient = sender as? Patient
        patieneDetailVC?.patient = patient
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let patient = self.patients[indexPath.row]
        
     performSegue(withIdentifier: "patientDetailsegue", sender: patient)
    }
}

class PatientCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
         detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return  imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        //x,y, width, height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PatientsViewController: UITableViewDelegate, UITableViewDataSource {
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
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profilePatientImageUrl)
            
        }
        return cell
    }
    
}

