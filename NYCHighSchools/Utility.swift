//
//  Utility.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/13/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit

// MARK: Debugging

func debug(_ cityHighSchoolsDataDict: [String:HighSchoolData]?) {
    print("\n________________________________________________________________")
    if cityHighSchoolsDataDict != nil {
        print("PARSED HIGH SCHOOLS DATA: \(cityHighSchoolsDataDict!.keys.count) schools")
        let allValues = cityHighSchoolsDataDict!.values
        for highSchoolData in allValues {
            highSchoolData.debug()
        }
    }
    else {
        print("No schools data parsed")
    }
}

func removeWhitespaceFromSchoolName(_ schoolName: String) -> String? {
    let realSchoolName = schoolName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard realSchoolName.count >= 2 else {
        return nil
    }
    return realSchoolName
}

