//
//  CityHighSchoolsTableViewController.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/10/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit

class CityHighSchoolsTableViewController: UITableViewController {

    var downloadAndParseXMLOperation: ParseCityHighSchoolsSATDataXMLTask?     // parse a city's high schools SAT data & school data
    var cityHighSchoolsSATData: [HighSchoolData]?           // list of city high schools data including SAT data
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func downloadAndParseCityHighSchoolsSATData() {
        guard downloadAndParseXMLOperation == nil else {
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let citySATInfo = appDelegate.cityHighSchoolsSATDataInfo else {
            return
        }
        
        let operation = ParseCityHighSchoolsSATDataXMLTask(withCitySATDataInfo: citySATInfo)
        operation.parse(completionHandler: downloadAndParseCityHighSchoolsSATDataCompletionHandler)
     }
    
    func downloadAndParseCityHighSchoolsSATDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                      error: ParseHighSchoolDataXMLError?) {
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            
            for highSchoolData in cityHighSchoolsDataDict!.values {
                highSchoolData.debug()
            }
            
            // save the lis of parsed city high school data including SAT data
            cityHighSchoolsSATData = Array(cityHighSchoolsDataDict!.values) as [HighSchoolData]
            
            print("SUCCESS! Parsed \(cityHighSchoolsSATData!.count) High School's SAT Data")
 //           debug(cityHighSchoolsDataDict)
        }
        else {
            print("PARSE ERROR! Could not parse City High School's SAT Data")
        }
    }
}
