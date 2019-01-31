//
//  Utility.swift
//  20190131-MattLintlop-NYCSchools
//
//  Created by Matt Lintlop on 1/31/2019.
//  Copyright © 2019 Matthew Lintlop. All rights reserved.
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

func showNetworkActivityIndicator() {
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
    }
}

func hideNetworkActivityIndicator() {
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
    }
}

