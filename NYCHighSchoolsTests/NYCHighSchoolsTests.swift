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
    
    var services: AppServices?

    override func setUp() {
        super.setUp()
        
        // get the app services
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("App delegate should not be nil")
            return
        }
        services = appDelegate.services
        XCTAssertNotNil(services, "AppServices should not be nil")
        
        // load the testing NYC High school names
        parse_test_NYC_HighSchools_XML_Data()
    }
    
   func parse_test_NYC_HighSchools_XML_Data() {
        let nycHighSchoolsXMLData = services?.load_Offline_NYC_HighSchools_XML_Data()
        XCTAssertNotNil(nycHighSchoolsXMLData, "NYC high school names testing data is nil")
        print("\n>> PARSING HIGH SCHOOL NAMES:")
        services?.parseHighSchoolNames(withXMLData: nycHighSchoolsXMLData!)
    }
    
    func test_parse_NYC_HighSchools_SAT_XML_Data() {
        let nycSATXMLData = services?.load_Offline_NYC_HighSchools_SAT_XML_Data()
        XCTAssertNotNil(nycSATXMLData, "NYC high schools SAT testing data is nil")
        print("\n>> PARSING HIGH SCHOOL SAT SCORES:")
        services?.parseHighSchoolSATScores(withXMLData: nycSATXMLData!)
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
