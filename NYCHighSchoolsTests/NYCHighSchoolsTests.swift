//
//  NYCHighSchoolsTests.swift
//  NYCHighSchoolsTests
//
//  Created by Matthew Lintlop on 2/1/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import XCTest
@testable import NYCHighSchools

class NYCHighSchoolsTests: XCTestCase {
    
    var parseHighSchoolDataExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        
        // get the app services
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("App delegate should not be nil")
            return
        }
      }
    
    func testParseHighSchoolData() {
        parseHighSchoolDataExpectation = XCTestExpectation(description: "Parse A High School's Data XML")
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's Data XML Expectation should not be nil")
            return
        }
        
        let bundle = Bundle(for: NYCHighSchoolsTests.self)
        guard let path = bundle.path(forResource: "Test_NYC_2017_High_Schools_Names", ofType: "xml") else {
            XCTFail("Error loading Test_NYC_2017_High_Schools_Names.xml")
           return
        }
        let url = URL(fileURLWithPath: path)
        
        
//        enum HighSchoolDataJSONItens: String {
//            case schoolName = "school_name"                                 // high school name
//            case numberOfTestTakers = "num_of_sat_test_takers"              // # of test takers
//            case averageSATReadingScore = "sat_critical_reading_avg_score"  // average SAT reading score
//            case averageSATMathScore = "sat_math_avg_score"                 // average SAT math score
//            case averageSATWritingScore = "sat_writing_avg_score"           // average SAT writing score
//            case overViewParagraph = "overview_paragraph"                   // overview paragraph
//            case phonNumber = "phone_number"                                // phone number
//            case faxNumber = "fax_number"                                   // fax number
//            case schoolEmail = "school_email"                               // school email
//            case numberOfStudents = "total_students"                        // number of students
//            case city = "city"                                              // city
//            case zip = "zip"                                                // zip code
//            case state = "state_code"                                       // state
//            case latitude = "latitude"                                      // latitude
//            case longitude = "longitude"                                    // longitude
//        }

        
        let jsonItemToParse: [String] = [HighSchoolDataJSONItens.schoolName.rawValue,
                                         HighSchoolDataJSONItens.overViewParagraph.rawValue,
                                         HighSchoolDataJSONItens.phonNumber.rawValue,
                                         HighSchoolDataJSONItens.faxNumber.rawValue,
                                         HighSchoolDataJSONItens.schoolEmail.rawValue,
                                         HighSchoolDataJSONItens.numberOfStudents.rawValue,
                                         HighSchoolDataJSONItens.city.rawValue,
                                         HighSchoolDataJSONItens.zip.rawValue,
                                         HighSchoolDataJSONItens.state.rawValue,
                                         HighSchoolDataJSONItens.latitude.rawValue,
                                         HighSchoolDataJSONItens.longitude.rawValue]
        
        let parseXMLOperation = ParseCityHighSchoolsDataXMLOperation(xmlDataURL: url,
                                                                     jsonItemsToParse: jsonItemToParse,
                                                                     completionHandler: parseHighSchoolDataCompletionHandler,
                                                                     cityHighSchoolsDataDict: nil,
                                                                     onlyParseDataForSchoolsInDict: false)
        parseXMLOperation.parse()
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func parseHighSchoolDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                 error: ParseHighSchoolDataXMLError?) {
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's Data XML Expectation should not be nil")
            return
        }
        
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsed A High School's Data: \(cityHighSchoolsDataDict?.debugDescription)")
        }
        expectation.fulfill()
    }
 
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
