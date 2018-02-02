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
    
    var nycHighSchoolsXMLData: Data?
    var nycSATXMLData: Data?
    var bundle: Bundle?
    var services: AppServices?

    override func setUp() {
        super.setUp()
        
        // create the app services
        services = AppServices()
        XCTAssertNotNil(services, "AppServices should not be nil")

        // get the bundle that contains this test class and not the main bundle
        bundle = Bundle(for: type(of: self))
        
        load_NYC_HighSchools_XML_Data()
//        load_NYC_HighSchools_SAT_XML_Data()
    }
    
    private func load_NYC_HighSchools_XML_Data() {
//        guard let path = bundle?.path(forResource: "Test_NYC_High_Schools_Names", ofType: "xml") else {
        guard let path = bundle?.path(forResource: "Test", ofType: "xml") else {
            XCTFail()
            return
        }
        let url = URL(fileURLWithPath: path)
        let nycHighSchoolsXMLData = try? Data(contentsOf: url)
        XCTAssertNotNil(nycHighSchoolsXMLData, "NYC high school names testing data is nil")
        print("\n>> PARSING HIGH SCHOOL NAMES:")
        services?.parseHighSchoolNames(withXMLData: nycHighSchoolsXMLData!)
        sleep(5)
        print("\n>> DONE HIGH SCHOOL NAMES:")
    }
    
    private func load_NYC_HighSchools_SAT_XML_Data() {
        guard let path = bundle?.path(forResource: "Test_NYC_High_Schools_SAT_Data", ofType: "xml") else {
            XCTFail()
            return
        }
        let url = URL(fileURLWithPath: path)
        let nycSATXMLData = try? Data(contentsOf: url)
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
