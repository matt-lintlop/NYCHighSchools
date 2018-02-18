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
    @IBOutlet weak var overviewParagrapTextView: UITextView!
    @IBOutlet weak var numberOfStudentsLabel: UILabel!
    @IBOutlet weak var avgMathSATLabel: UILabel!
    @IBOutlet weak var avgReadingSATLabel: UILabel!
    @IBOutlet weak var avgWritingSAT: UILabel!
    @IBOutlet weak var numberOfTestTakersLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stateLabel: UILabel!
    
    var highSchoolData: HighSchoolData?         // high school's data including average SAT scores
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHighSchoolData()
    }
    
    override func viewDidLoad() {
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        navigationItem.rightBarButtonItem = settingsButton
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
    
    func showHighSchoolData() {
        guard let highSchoolData = self.highSchoolData else {
            print("In showHighSchoolData() highSchoolData = NIL")
            return
        }
        
        print("=========================================")
        self.highSchoolData?.debug("Showing High School Data")
        
        // show the shool name
        self.highSchoolNameLabel.text = highSchoolData.schoolName
        
        // show the school's primary address
        if let primaryAddress = highSchoolData.primaryAddress {
            addressLabel.text = primaryAddress
        }

        // show the school's city
        if let city = highSchoolData.city {
            cityLabel.text = city
        }
        else {
            cityLabel.text = ""
        }
 
        // show the school's zip code
        if let zip = highSchoolData.zip {
            zipCodeLabel.text = zip
        }
        else {
            zipCodeLabel.text = ""
        }
 
        // show the school's state
        if let state = highSchoolData.state {
            stateLabel.text = state
        }
        else {
            stateLabel.text = ""
        }

        // show the number of SAT test takers at the school
        if let numberOfSATTestTakers = highSchoolData.numberOfSATTestTakers {
            numberOfTestTakersLabel.text = String(numberOfSATTestTakers)
        }
        else {
            numberOfTestTakersLabel.text = ""
        }
        
        // show the average SAT reading score at the school
        if let averageSATReadingScore = highSchoolData.averageSATReadingScore {
            avgReadingSATLabel.text = String(averageSATReadingScore)
        }
        else {
            avgReadingSATLabel.text = ""
        }
        
        // show the average SAT math score at the school
        if let averageSATMathScore = highSchoolData.averageSATMathScore {
            avgMathSATLabel.text = String(averageSATMathScore)
        }
        else {
            avgMathSATLabel.text = ""
        }
        
        // show the average SAT writing score at the school
        if let averageSATWritingScore = highSchoolData.averageSATWritingScore {
            avgWritingSAT.text = String(averageSATWritingScore)
        }
        else {
            avgWritingSAT.text = ""
        }
        
        // show theschool's email address
        if let schoolEmail = highSchoolData.schoolEmail {
            emailLabel.text = schoolEmail
        }
        else {
            emailLabel.text = ""
        }
        
        // show the school's overview paragraph
        if let overview = highSchoolData.overViewParagraph {
            overviewParagrapTextView.text = overview
        }
        else {
            overviewParagrapTextView.text = ""
        }
        
        // show the school's phone number
        if let phoneNumber = highSchoolData.phoneNumber {
            phoneLabel.text = phoneNumber
        }
        else {
            phoneLabel.text = ""
        }
        
        // show the school's fax number
        if let faxNumber = highSchoolData.faxNumber {
            faxLabel.text = faxNumber
        }
        else {
            faxLabel.text = ""
        }
        
        // show the total number of students at the school
        if let numberOfStudents = highSchoolData.numberOfStudents {
            numberOfStudentsLabel.text = String(numberOfStudents)
        }
        else {
            numberOfStudentsLabel.text = ""
        }
        
        // show all of the overview paragraph text
        var frame = self.overviewParagrapTextView.frame
        frame.size.height = self.overviewParagrapTextView.contentSize.height
        self.overviewParagrapTextView.frame = frame
        updateMapWithSchoolLocation()

        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func updateMapWithSchoolLocation() {
        guard let mapView = mapView else {
            return
        }
        guard let latitude = highSchoolData?.latitude, let longitude = highSchoolData?.longitude else {
            mapView.isHidden = true
            return
        }
        var region = MKCoordinateRegion()
        region.center.latitude = CLLocationDegrees(latitude);
        region.center.longitude = CLLocationDegrees(longitude);
        region.span.latitudeDelta = 0.007285714285714       // 1 mile
        region.span.longitudeDelta = 0.007285714285714      // 1 mile
        mapView.region = region
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
