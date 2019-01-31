//
//  HomeViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/10/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {

    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    var appoinments = [Citas]()
    let cellId = "cellId"
    
    
    //Ouletss
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.refreshControl = refresher
        
       guard let username =  Auth.auth().currentUser?.displayName else { return }
        testLabel.text = "Hello \(username)"

        tableView.register(AppoinmentCellWithImage.self, forCellReuseIdentifier: cellId)
        
        fetchUserDeletingOldsAppoinmets()
        
        Auth.auth().addStateDidChangeListener { auth, user in
           
        }
        tableView.allowsSelectionDuringEditing = true

    
    }
    
    @objc func requestData() {
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.fetchUserDeletingOldsAppoinmets()
            self.refresher.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appoinment = self.appoinments[indexPath.row]
        
        guard let documentId = appoinment.appoinmentId else {
            return
        }
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        
        db.collection("Citas").document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                return
            } else {
                self.appoinments.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Document successfully removed!")
            }
            
        }
    }
    
    func fetchUserDeletingOldsAppoinmets() {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("Citas").getDocuments() { (querySnapshot, err) in
            
            self.appoinments.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let appoinmentDyFound = document.get("appoinmentDay") as! String
                    let appoinmentHourFound = document.get("appoinmentHour") as! String
                    let imageUrlFound = document.get("profileImageUrl") as! String
                    let doctorUidFound = document.get("doctorUid") as! String
                    let patientIdFound = document.get("idPatient") as! String
                    
                    let appoinment = Citas()
                    appoinment.appoinmentHour = appoinmentHourFound
                    appoinment.appoinmentDay = appoinmentDyFound
                    appoinment.profileImageUrl = imageUrlFound
                    appoinment.doctorUid = doctorUidFound
                    appoinment.idPatient = patientIdFound
                    
                    self.appoinments.append(appoinment)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let patieneDetailVC = segue.destination as? PatientDetailViewController
        let patient = sender as? Patient
        patieneDetailVC?.patient = patient
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let appoinment = self.appoinments[indexPath.row]
//
//        performSegue(withIdentifier: "patientDetailsegue", sender: patient)
//    }
   
}

class AppoinmentCellWithImage: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 135, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 138, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
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


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appoinments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AppoinmentCellWithImage
        //we need to dequeue the cells for memory efficiency
        let appoinment = appoinments[indexPath.row]
        cell.textLabel?.text = appoinment.appoinmentDay
        cell.detailTextLabel?.text = appoinment.appoinmentHour
        
        if let profilePatientImageUrl = appoinment.profileImageUrl {
            
    cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profilePatientImageUrl)
            
        }
        return cell
    }
    
    
}
