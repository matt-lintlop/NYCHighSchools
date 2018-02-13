//
//  HighSchoolData.swift
//  NYCHighSchools
//
//  This class has information about a single city high school.
//  Created by Matthew Lintlop on 2/1/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import Foundation

class HighSchoolData {
    var schoolName: String              // high school name
    var numberOfSATTestTakers: Int?     // # of test takers
    var averageSATReadingScore: Float?  // average SAT reading score
    var averageSATMathScore: Float?     // average SAT math score
    var averageSATWritingScore: Float?  // average SAT writing score
    var overViewParagraph: String?      // overview paragraph
    var phonNumber: String?             // phone number
    var faxNumber: String?              // fax number
    var schoolEmail: String?            // school email
    var numberOfStudents: Int?          // number of students
    var city: String?                   // city
    var zip: String?                    // zip code
    var state: String?                  // state
    var latitude: Float?                  // latitude
    var longitude: Float?                 // longitude

    init(schoolName: String) {
        self.schoolName = schoolName
        
        if schoolName == "Design" {
            print("hi")
        }
    }
    
    // MARK: Debugging
    
    func debug() {
        print("\nHighSchoolData for school name: \(schoolName)")
        print("numberOfSATTestTakers: \(String(describing: numberOfSATTestTakers))")
        print("averageSATReadingScore: \(String(describing: averageSATReadingScore))")
        print("averageSATMathScore: \(String(describing: averageSATMathScore))")
        print("averageSATWritingScore: \(String(describing: averageSATWritingScore))")
        print("overViewParagraph: \(String(describing: overViewParagraph))")
        print("phonNumber: \(String(describing: phonNumber))")
        print("faxNumber: \(String(describing: faxNumber))")
        print("schoolEmail: \(String(describing: schoolEmail))")
        print("numberOfStudents: \(String(describing: numberOfStudents))")
        print("city: \(String(describing: city))")
        print("zip: \(String(describing: zip))")
        print("state: \(String(describing: state))")
        print("latitude: \(String(describing: latitude))")
        print("longitude: \(String(describing: longitude))")
    }
}
