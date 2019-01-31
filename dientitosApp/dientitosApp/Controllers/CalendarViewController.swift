//
//  CalendarViewController.swift
//  dientitosApp
//
//  Created by Itzel GoOm on 1/17/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController,UICollectionViewDelegate {
    
    
//Outlets
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var calendarCV: UICollectionView!

//Variables
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    var numberOfEmptyBox =  Int()
    var nextNumberOfEmptyBox = Int()
    var previousNumberOfEmptyBox = 0
    var direction = 0
    var positionIndex = 0
    var leapYearCounter = 3
    var dayCounter = 0
    var highlightDate = -1
    var dateString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        getStartDateDayPosition()
    }
    

    //MARK: Configuration buttons next month and back month
    
    @IBAction func nextMonth(_ sender: Any) {
        highlightDate = -1

        switch currentMonth {
        case "December":
            direction = 1
            month = 0
            year += 1
 
            if leapYearCounter  < 5 {
                leapYearCounter += 1
            }
            
            if leapYearCounter == 4 {
                DaysInMonths[1] = 29
            }
            
            if leapYearCounter == 5{
                leapYearCounter = 1
                DaysInMonths[1] = 28
            }
            
            getStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calendarCV.reloadData()
            
        default:
            direction = 1
            getStartDateDayPosition()
            month += 1
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calendarCV.reloadData()
        }
    }
    
    @IBAction func backMonth(_ sender: Any) {
        highlightDate = -1
        switch currentMonth {
        case "January":
            direction = -1
            month = 11
            year -= 1
            
            if leapYearCounter > 0{
                leapYearCounter -= 1
            }
            if leapYearCounter == 0{
                DaysInMonths[1] = 29
                leapYearCounter = 4
            }else{
                DaysInMonths[1] = 28
            }
            
            getStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calendarCV.reloadData()
            
        default:
            direction = -1
            month -= 1
            getStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calendarCV.reloadData()
        }
    }
    
    // MARK: - Configuration EmptyBox of month
    //Function to know how many empty boxes the month will have
    
    func getStartDateDayPosition(){
        switch direction {
        case 0:
           numberOfEmptyBox = weekday
            dayCounter = day
           while dayCounter>0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
           if numberOfEmptyBox == 7 {
            numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + DaysInMonths[month])%7
            positionIndex = nextNumberOfEmptyBox
            
        case -1:
            previousNumberOfEmptyBox = (7 - (DaysInMonths[month] - positionIndex)%7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }

 
}


extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return DaysInMonths[month] + numberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + nextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        cell.circle.isHidden = true
        
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - numberOfEmptyBox == day{
            cell.circle.isHidden = false
            cell.DrawCircle()
        }
        
        if highlightDate == indexPath.row {
            cell.backgroundColor = UIColor.red
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Aqui va el segue para que al dar clic se vaya al view de las citas
        dateString = "\(indexPath.row - positionIndex + 1) \(currentMonth) \(year)"
        highlightDate = indexPath.row
        collectionView.reloadData()
    }

    
}
