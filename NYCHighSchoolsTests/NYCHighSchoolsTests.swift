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
    
    override func setUp() {
        super.setUp()
        
        // get the app services
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("App delegate should not be nil")
            return
        }
      }
    
    func parse_Offline_NYC_HighSchool_Names_XML_Data() {
        guard let path = Bundle.main.path(forResource: "NYC_2017_High_Schools_Names", ofType: "xml") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        let jsonItemToParse: [String] = []
        let parseXMLOperation = ParseHighSchoolDataXMLOperation(xmlDataURL: url,
                                                                jsonItemsToParse: jsonItemToParse,
                                                                completionHandler: parseHighSchoolXMLDataCompletionHandler,
                                                                cityHighSchoolsDataDict: nil,
                                                                onlyParseDataForSchoolsInDict: false)
        parseXMLOperation.parse()
        
    }
    
    func parseHighSchoolXMLDataCompletionHandler(highSchoolsDataDict: [String:HighSchoolData]?,
                                                 error: ParseHighSchoolDataXMLError?) {
        
    }
 
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
