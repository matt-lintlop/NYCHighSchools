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
        
        // get the app services
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("App delegate should not be nil")
            return
        }
        services = appDelegate.services
        XCTAssertNotNil(services, "AppServices should not be nil")

        // get the bundle that contains this test class and not the main bundle
        bundle = Bundle(for: type(of: self))
        
        load_NYC_HighSchools_XML_Data()
        load_NYC_HighSchools_SAT_XML_Data()
    }
    
    private func load_NYC_HighSchools_XML_Data() {
        guard let path = bundle?.path(forResource: "Test_NYC_High_Schools_Names", ofType: "xml") else {
            XCTFail()
            return
        }
        let url = URL(fileURLWithPath: path)
        
        guard var nycHighSchoolsXMLString = try? String(contentsOf: url, encoding: .utf8) else {
            XCTFail("NYC High School Test XML string = nil")
            return
        }
        nycHighSchoolsXMLString = services!.replaceAmpersandInXML(nycHighSchoolsXMLString)
        
        let nycHighSchoolsXMLData = nycHighSchoolsXMLString.data(using: .utf8)
        XCTAssertNotNil(nycHighSchoolsXMLData, "NYC high school names testing data is nil")
        print("\n>> PARSING HIGH SCHOOL NAMES:")
        services?.parseHighSchoolNames(withXMLData: nycHighSchoolsXMLData!)
    }
    
    private func load_NYC_HighSchools_SAT_XML_Data() {
        guard let path = bundle?.path(forResource: "Test_NYC_High_Schools_SAT_Data", ofType: "xml") else {
            XCTFail()
            return
        }
        let url = URL(fileURLWithPath: path)
        guard var nycHighSchoolsSATDataXMLString = try? String(contentsOf: url, encoding: .utf8) else {
            XCTFail("NYC High Schools Test SAT Data XML string = nil")
            return
        }
        nycHighSchoolsSATDataXMLString = services!.replaceAmpersandInXML(nycHighSchoolsSATDataXMLString)
        let nycSATXMLData = nycHighSchoolsSATDataXMLString.data(using: .utf8)
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
