//
//  CityHighSchoolSATData.swift
//  NYCHighSchools
//
//  Created by Matthew Lintlop on 2/1/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import Foundation

struct CityHighSchoolSATData {
    var name: String                // name of the High School
    var satReadingScore: Float      // average SAT Reading score
    var satWritingScore: Float      // average SAT Writing score
    var satMathScore: Float         // average SAT Math score
    var testTakersCount: Int        // Number of Test Takers
    
    init(name: String) {
        self.name = name
        self.satMathScore = 0.0
        self.satReadingScore = 0.0
        self.satWritingScore = 0.0
        self.testTakersCount = 0
    }
}
