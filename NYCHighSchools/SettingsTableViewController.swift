//
//  SettingsTableViewController.swift
//  20190130-MattLintlop-NYCSchools
//
//  Created by Matt Lintlop on 1/30/2019.
//  Copyright © 2019 Matthew Lintlop. All rights reserved.
//

import UIKit

// Notifictions
// Did Set High School Data Sort Type notification key
let didSetSetHighSchoolDataSortTypeNotification: Notification.Name = Notification.Name(rawValue: "com.mattlintlop.didSetHighSchoolDataSortType")

class SettingsTableViewController: UITableViewController {

    var selectedCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 44;
        self.clearsSelectionOnViewWillAppear = false

        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let sortDataByType = appDelegate.getHighSchoolDataSortType()
            checkCell(withIndexPath: getIndexPath(withDataSortType: sortDataByType))
        }
        
     }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sort By:"
        }
        else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortDataTypeCell", for: indexPath) as! SortDataTypeCell

        switch indexPath.row {
         case 0:
            cell.sortTypeLabel.text = HighSchoolDataSortType.highSchoolName.rawValue
        case 1:
            cell.sortTypeLabel.text = HighSchoolDataSortType.bestAvgMathSATScore.rawValue
        case 2:
            cell.sortTypeLabel.text = HighSchoolDataSortType.bestAvgReadingSATScore.rawValue
        case 3:
            cell.sortTypeLabel.text = HighSchoolDataSortType.bestAvgWritingSATScore.rawValue
        case 4:
            cell.sortTypeLabel.text = HighSchoolDataSortType.maxNumberOfSATTestTakers.rawValue
        case 5:
            cell.sortTypeLabel.text = HighSchoolDataSortType.maxNumberOfStudents.rawValue
        default:
            cell.sortTypeLabel.text = HighSchoolDataSortType.highSchoolName.rawValue
        }
        
        if let selectedCellIndexPath = self.selectedCellIndexPath {
            if selectedCellIndexPath.row == indexPath.row {
                cell.backgroundColor = UIColor.lightGray
            }
            else {
                cell.backgroundColor = UIColor.white
            }
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let dataSortType = getDataSortType(withIndexPath: indexPath)
        appDelegate.setHighSchoolDataSortType(dataSortType)
        checkCell(withIndexPath: indexPath)
    }
    
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
    
    func getIndexPath(withDataSortType dataSortType: HighSchoolDataSortType) -> IndexPath {
        switch dataSortType {
        case .highSchoolName:
            return IndexPath(row: 0, section: 0)
            
        case .bestAvgMathSATScore:
            return IndexPath(row: 1, section: 0)
            
        case .bestAvgReadingSATScore:
            return IndexPath(row: 2, section: 0)
            
        case .bestAvgWritingSATScore:
            return IndexPath(row: 3, section: 0)
            
        case .maxNumberOfSATTestTakers:
            return IndexPath(row: 4, section: 0)
            
        case .maxNumberOfStudents:
            return IndexPath(row: 5, section: 0)
        }
    }
    
    func getDataSortType(withIndexPath indexPath: IndexPath) -> HighSchoolDataSortType {
        switch indexPath.row {
        case 0:
            return .highSchoolName
        case 1:
            return .bestAvgMathSATScore
        case 2:
            return .bestAvgReadingSATScore
        case 3:
            return .bestAvgWritingSATScore
        case 4:
            return .maxNumberOfSATTestTakers
        case 5:
            return .maxNumberOfStudents
        default:
            return .highSchoolName
        }
    }
    
    func checkCell(withIndexPath indexPath: IndexPath) {
        if let currentSelectedCellIndexPath = self.selectedCellIndexPath {
            self.selectedCellIndexPath = indexPath
            self.tableView.reloadRows(at: [currentSelectedCellIndexPath, indexPath], with: .none)
        }
        else {
            self.selectedCellIndexPath = indexPath
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
 
}
