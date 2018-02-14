//
//  HighSchoolDetailViewController.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/13/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit
import MapKit

class HighSchoolDetailViewController: UIViewController {
    
   
    @IBOutlet weak var highSchoolNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var faxLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var numberOfStudentsLabel: UILabel!
    @IBOutlet weak var avgMathSATLabel: UILabel!
    @IBOutlet weak var avgReadingSATLabel: UILabel!
    @IBOutlet weak var avgWritingSAT: UILabel!
    @IBOutlet weak var numberOfTestTakersLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stateLabel: UILabel!
    
    var highSchoolData: HighSchoolData?    // high school's data including average SAT scores
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        navigationItem.rightBarButtonItem = settingsButton
        showLabelsWithData()
    }

    @objc func settingsTapped() {
        guard let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsTableViewController") else {
            return
        }
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHighSchoolData(_ highSchoolData: HighSchoolData) {
        self.highSchoolData = highSchoolData
    }
    
    func showLabelsWithData() {
        guard let highSchoolData = highSchoolData else {
            return
        }
        self.title = highSchoolData.schoolName
        self.highSchoolNameLabel.text = highSchoolData.schoolName
        if let primaryAddress = highSchoolData.primaryAddress {
            addressLabel.text = primaryAddress
        }

        if let city = highSchoolData.city {
            cityLabel.text = city
        }
        else {
            cityLabel.text = ""
        }
        if let zip = highSchoolData.zip {
            zipCodeLabel.text = zip
        }
        else {
            zipCodeLabel.text = ""
        }
        if let state = highSchoolData.state {
            stateLabel.text = state
        }
        else {
            stateLabel.text = ""
        }
        if let numberOfSATTestTakers = highSchoolData.numberOfSATTestTakers {
            numberOfTestTakersLabel.text = String(numberOfSATTestTakers)
        }
        else {
            numberOfTestTakersLabel.text = ""
        }
        
        if let averageSATReadingScore = highSchoolData.averageSATReadingScore {
            avgReadingSATLabel.text = String(averageSATReadingScore)
        }
        else {
            avgReadingSATLabel.text = ""
        }
        
        if let averageSATMathScore = highSchoolData.averageSATMathScore {
            avgMathSATLabel.text = String(averageSATMathScore)
        }
        else {
            avgMathSATLabel.text = ""
        }
        
        if let averageSATWritingScore = highSchoolData.averageSATWritingScore {
            avgWritingSAT.text = String(averageSATWritingScore)
        }
        else {
            avgWritingSAT.text = ""
        }
        
        if let schoolEmail = highSchoolData.schoolEmail {
            emailLabel.text = schoolEmail
        }
        else {
            emailLabel.text = ""
        }
        
        if let overViewParagraph = highSchoolData.overViewParagraph {
            overviewLabel.text = overViewParagraph
        }
        else {
            overviewLabel.text = ""
        }
        
        if let phonNumber = highSchoolData.phonNumber {
            phoneLabel.text = phonNumber
        }
        else {
            phoneLabel.text = ""
        }
        
        if let faxNumber = highSchoolData.faxNumber {
            faxLabel.text = faxNumber
        }
        else {
            faxLabel.text = ""
        }
        
        if let numberOfStudents = highSchoolData.numberOfStudents {
            numberOfStudentsLabel.text = String(numberOfStudents)
        }
        else {
            numberOfStudentsLabel.text = ""
        }

        highSchoolData.debug()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
