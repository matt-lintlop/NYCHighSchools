//
//  HighSchoolData.swift
//  NYCHighSchools
//
//  Created by Matthew Lintlop on 2/1/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import Foundation

struct HighSchoolData {
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
    var latitude: Int?                  // latitude
    var longitude: Int?                 // longitude

    init(schoolName: String) {
        self.schoolName = schoolName
    }
}
