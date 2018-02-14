//
//  HighSchoolDetailViewController.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/13/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit

class HighSchoolDetailViewController: UIViewController {
    
    @IBOutlet weak var highSchoolNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var faxLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    var highSchoolData: HighSchoolData?    // high school's data including average SAT scores
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func setHighSchoolData(_ highSchoolData: HighSchoolData) {
        self.highSchoolData = highSchoolData
        self.title = highSchoolData.schoolName
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
