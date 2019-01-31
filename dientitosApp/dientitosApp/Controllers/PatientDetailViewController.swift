//
//  PatientDetailViewController.swift
//  dientitosApp
//
//  Created by Adrian on 1/24/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase

class PatientDetailViewController: UIViewController {
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    var appoinments = [Citas]()
    let imageCache = NSCache<AnyObject, AnyObject>()
    let cellId = "Cell"
    
    @IBOutlet weak var imagePatient: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!

    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var patientPhoneLabel: UILabel!
    @IBOutlet weak var patientEmailLabel: UILabel!
    var image = UIImage()
    var patient: Patient?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientDetail()
        tableView.refreshControl = refresher

        tableView.register(AppoinmentCell.self, forCellReuseIdentifier: cellId)
        
        fetchAppoinment()
        reloadInputViews()
        
    }
    
    @objc func requestData() {
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.fetchAppoinment()
            self.refresher.endRefreshing()
        }
    }
    
    func realodTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    
    func fetchAppoinment() {
    let db = Firestore.firestore()
        let settings = db.settings
        let currentDoctor = fetchUserLoggedIn()
        let currentPatient = patient?.uid
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("Citas").getDocuments { (QuerySnapshot, error) in
         
            self.appoinments.removeAll()
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for documents in QuerySnapshot!.documents {
                    let appoinmentDayFound = documents.get("appoinmentDay") as! String
                    let appoinmentHourFound = documents.get("appoinmentHour") as! String
                    let doctorUidFound = documents.get("doctorUid") as! String
                    let patientUidFound = documents.get("idPatient") as! String
                    
                    let appoinment = Citas()
                    appoinment.appoinmentDay = appoinmentDayFound
                    appoinment.appoinmentHour = appoinmentHourFound
                    appoinment.doctorUid = doctorUidFound
                    appoinment.idPatient = patientUidFound
                    
                    
                    if currentDoctor == doctorUidFound && currentPatient == patientUidFound {
                        self.appoinments.append(appoinment)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        //check cache for image first
        if let cacheimage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = (cacheimage as! UIImage)
            return
       }
    }
   
    func patientDetail(){
        patientNameLabel.text = patient?.name
        ageLabel.text = patient?.age
        patientPhoneLabel.text = patient?.phone
        patientEmailLabel.text = patient?.email
        imagePatient.image = UIImage(named: "user")
        
        if let profileImageUrl = patient!.profileImagenUrl {
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!) { (data, responde, error) in
            
                if error != nil {
                    print(error ?? "error")
                    return
                }
                DispatchQueue.main.async {
                    self.imagePatient?.image = UIImage(data: data!)
                }
            }.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? popUpViewController
        let patient = sender as? Patient
        destVC?.patient = sender  as? Patient
        print(patient!)
        
    }
    
    func saveInfo() {
        let patientToSend = patient
        performSegue(withIdentifier: "appoinmentSegue", sender: patientToSend)
    }

    @IBAction func popUpVCButtonPressed(_ sender: UIButton) {
        saveInfo()
    }
    
    
}

extension PatientDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appoinments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AppoinmentCell
        
        let appoinment = appoinments[indexPath.row]
        cell.textLabel?.text = appoinment.appoinmentDay
        cell.detailTextLabel?.text = appoinment.appoinmentHour
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


class AppoinmentCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
