//
//  CityHighSchoolsTableViewController.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/10/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit

enum HighSchoolDataSortType {
    case highSchoolName                       // sort by high school name alphabetically
    case bestAvgMathSATScore                  // sort by best average math SAT score
    case bestAvgReadingSATScore               // sort by best average reading SAT score
    case bestAvgWritingSATScore               // sort by best average writing SAT score
    case maxNumberOfSATTestTakers             // sort by maximum number of SAT test takers
    case maxNumberOfStudents                  // sort by maximum number of students
}

class CityHighSchoolsTableViewController: UITableViewController {

    var downloadAndParseXMLOperation: ParseCityHighSchoolsSATDataXMLTask?     // parse a city's high schools SAT data & school data
    var cityHighSchoolsSATData: [HighSchoolData]?                             // list of city high schools data including SAT data
    var sortedCityHighSchoolsSATData: [HighSchoolData]?                       // sorted list of city high schools data including SAT data
    var dataSortType: HighSchoolDataSortType = .highSchoolName                // current high school data sort type
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44;
        self.title = "NYC High Schools"
        
        downloadAndParseCityHighSchoolsSATData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sortedCityHighSchoolsSATData = sortedCityHighSchoolsSATData else {
            return 0
        }
        let rowCount = sortedCityHighSchoolsSATData.count
        print("There are \(rowCount) rows in the table view.")
        return rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighSchoolNameCell", for: indexPath) as! HighSchoolNameCell

        if let highSchoolData = self.sortedCityHighSchoolsSATData?[indexPath.row] {
            cell.highSchoolNameLabel.text = highSchoolData.schoolName
        }
        cell.layoutIfNeeded()
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
           return "City High Schools"
        }
        else {
            return nil
        }
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // get the general information about the city SAT data
    // including the url's to the xml data online & offline
    func cityHighSchoolsXMLDataInfo() -> CityHighSchoolsSATDataInfo? {
        guard downloadAndParseXMLOperation == nil else {
            return nil
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.cityHighSchoolsSATDataInfo
    }
    
    func downloadAndParseCityHighSchoolsSATData() {
        guard downloadAndParseXMLOperation == nil else {
            return
        }
        guard let cityXMLDataInfo = cityHighSchoolsXMLDataInfo() else {
            return
        }
        let operation = ParseCityHighSchoolsSATDataXMLTask(withCitySATDataInfo: cityXMLDataInfo)
        operation.parse(completionHandler: downloadAndParseCityHighSchoolsDataCompletionHandler)
     }
    
    func downloadAndParseCityHighSchoolsDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                              error: ParseHighSchoolDataXMLError?) {
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            
            for highSchoolData in cityHighSchoolsDataDict!.values {
                highSchoolData.debug()
            }
            
            // save the lis of parsed city high school data including SAT data
            cityHighSchoolsSATData = Array(cityHighSchoolsDataDict!.values) as [HighSchoolData]
            sortAndReloadTableviewData()
            
            print("SUCCESS! Parsed \(cityHighSchoolsSATData!.count) High School's SAT Data")
 //           debug(cityHighSchoolsDataDict)
        }
        else {
            print("PARSE ERROR! Could not parse City High School's SAT Data")
        }
    }
    
    func sortAndReloadTableviewData() {
        
        guard let cityHighSchoolsSATData = cityHighSchoolsSATData else {
            return
        }
        DispatchQueue.main.async {
            self.sortedCityHighSchoolsSATData = cityHighSchoolsSATData.sorted(by: ({ (highSchoolData1, highSchoolData2) -> Bool in
                switch self.dataSortType {
                case .highSchoolName:
                    // sort by high school name alphabetically
                    return highSchoolData1.schoolName < highSchoolData2.schoolName
                    
                case .bestAvgMathSATScore:
                    // sort by Best Average Math SAT Score
                    if highSchoolData1.averageSATMathScore == nil {
                        return false
                    }
                    if highSchoolData2.averageSATMathScore == nil {
                        return true
                    }
                    return highSchoolData1.averageSATMathScore! < highSchoolData2.averageSATMathScore!
                    
                case .bestAvgReadingSATScore:
                    // sort by Best Average Reading SAT Score
                    if highSchoolData1.averageSATReadingScore == nil {
                        return false
                    }
                    if highSchoolData2.averageSATReadingScore == nil {
                        return true
                    }
                    return highSchoolData1.averageSATReadingScore! < highSchoolData2.averageSATReadingScore!
                    
                case .bestAvgWritingSATScore:
                    // sort by Best Average Writing SAT Score
                    if highSchoolData1.averageSATWritingScore == nil {
                        return false
                    }
                    if highSchoolData2.averageSATWritingScore == nil {
                        return true
                    }
                    return highSchoolData1.averageSATWritingScore! < highSchoolData2.averageSATWritingScore!
                    
                case .maxNumberOfSATTestTakers:
                    // sort by Maximum Number of SAT Test Takers
                    if highSchoolData1.numberOfSATTestTakers == nil {
                        return false
                    }
                    if highSchoolData2.numberOfSATTestTakers == nil {
                        return true
                    }
                    return highSchoolData1.numberOfSATTestTakers! < highSchoolData2.numberOfSATTestTakers!
                    
                case .maxNumberOfStudents:
                    // sort by Maximum Number of SAT Test Takers
                    if highSchoolData1.numberOfStudents == nil {
                        return false
                    }
                    if highSchoolData2.numberOfStudents == nil {
                        return true
                    }
                    return highSchoolData1.numberOfStudents! < highSchoolData2.numberOfStudents!
                }
            }))
            self.tableView.reloadData()
       }
    }
    
}
