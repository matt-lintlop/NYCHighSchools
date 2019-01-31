//
//  20190131-MattLintlop-NYCSchoolsTests.swift
//  20190131-MattLintlop-NYCSchoolsTests
//
//  Created by Matthew Lintlop on 1/29/2019.
//  Copyright © 2019 Matthew Lintlop. All rights reserved.
//

import XCTest
@testable import 20190131-MattLintlop-NYCSchools

class NYCHighSchoolsTests: XCTestCase {
    
    var parseHighSchoolDataExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        
        // get the app services
    }
    
    func testParseOfflineHighSchoolData() {
        parseHighSchoolDataExpectation = XCTestExpectation(description: "Parse A High School's Data XML")
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's Data XML Expectation should not be nil")
            return
        }
        let bundle = Bundle(for: type(of:self))
        guard let path = bundle.path(forResource: "Test_NYC_High_Schools_Names", ofType: "xml") else {
            XCTFail("Error loading Test_NYC_2017_High_Schools_Names.xml")
           return
        }
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
        
        let parseXMLOperation = ParseCityHighSchoolsDataXMLOperation(jsonItemsToParse: jsonItemToParse,
                                                                     completionHandler: parseOfflineHighSchoolDataCompletionHandler,
                                                                     cityHighSchoolsDataDict: nil,
                                                                     addAllParsedItems: true)
        let url = URL(fileURLWithPath: path)
        parseXMLOperation.parseXML(withURL: url)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func parseOfflineHighSchoolDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                     error: ParseHighSchoolDataXMLError?) {
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's Data XML Expectation should not be nil")
            return
        }
        
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsed A High School's Data: \(cityHighSchoolsDataDict?.debugDescription)")
            expectation.fulfill()
        }
    }

    func testParseOfflineHighSchoolSATData() {
        parseHighSchoolDataExpectation = XCTestExpectation(description: "Parse A High School's SAT Data XML")
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's SAT Data XML Expectation should not be nil")
            return
        }
        
        let bundle = Bundle(for: type(of:self))
        print("Loading from bundle: \(bundle.bundlePath)")
        guard let path = bundle.path(forResource: "Test_NYC_High_Schools_SAT_Data", ofType: "xml") else {
            XCTFail("Error loading Test_NYC_High_Schools_SAT_Data")
            return
        }
        let jsonItemToParse: [String] = [HighSchoolDataJSONItens.schoolName.rawValue,
                                         HighSchoolDataJSONItens.averageSATMathScore.rawValue,
                                         HighSchoolDataJSONItens.averageSATReadingScore.rawValue,
                                         HighSchoolDataJSONItens.averageSATWritingScore.rawValue,
                                         HighSchoolDataJSONItens.numberOfTestTakers.rawValue]
        
        let parseXMLOperation = ParseCityHighSchoolsDataXMLOperation(jsonItemsToParse: jsonItemToParse,
                                                                     completionHandler: parseHighSchoolSATDataCompletionHandler,
                                                                     cityHighSchoolsDataDict: nil,
                                                                     addAllParsedItems: true)
        let url = URL(fileURLWithPath: path)
        parseXMLOperation.parseXML(withURL: url)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func parseHighSchoolSATDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                 error: ParseHighSchoolDataXMLError?) {
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's SAT Data XML Expectation should not be nil")
            return
        }
        
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsed A High School's SAT Data")
            expectation.fulfill()
        }
    }

    func testParseNetworkHighSchoolData() {
        parseHighSchoolDataExpectation = XCTestExpectation(description: "Parse A High School's Data XML")
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's Data XML Expectation should not be nil")
            return
        }
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
        
        let parseXMLOperation = ParseCityHighSchoolsDataXMLOperation(jsonItemsToParse: jsonItemToParse,
                                                                     completionHandler: parseNetworkHighSchoolDataCompletionHandler,
                                                                     cityHighSchoolsDataDict: nil,
                                                                     addAllParsedItems: true)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("App delegate should not be nil")
            return
        }
        guard let cityXMLDataInfo = appDelegate.cityHighSchoolsSATDataInfo else {
            XCTFail("City SAT infoi should not be nil")
            return
        }
        guard let url = cityXMLDataInfo.cityHighSchoolDataURL else {
            XCTFail("Bad URL for High School's Data XML")
            return
        }
        parseXMLOperation.parseXML(withURL: url)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func parseNetworkHighSchoolDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                     error: ParseHighSchoolDataXMLError?) {
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's Data XML from Network Expectation should not be nil")
            return
        }
        
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsed A High School's Data from Network")
            expectation.fulfill()
        }
    }
    
    func testParseNetworkHighSchoolSATData() {
        parseHighSchoolDataExpectation = XCTestExpectation(description: "Parse A High School's SAT Data XML")
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's SAT Data XML from Networ Expectation should not be nil")
            return
        }
        
        let jsonItemToParse: [String] = [HighSchoolDataJSONItens.schoolName.rawValue,
                                         HighSchoolDataJSONItens.averageSATMathScore.rawValue,
                                         HighSchoolDataJSONItens.averageSATReadingScore.rawValue,
                                         HighSchoolDataJSONItens.averageSATWritingScore.rawValue,
                                         HighSchoolDataJSONItens.numberOfTestTakers.rawValue]
        
        let parseXMLOperation = ParseCityHighSchoolsDataXMLOperation(jsonItemsToParse: jsonItemToParse,
                                                                     completionHandler: parseHighSchoolSATDataFromNetworkCompletionHandler,
                                                                     cityHighSchoolsDataDict: nil,
                                                                     addAllParsedItems: true)
   
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("App delegate should not be nil")
            return
        }
        guard let cityXMLDataInfo = appDelegate.cityHighSchoolsSATDataInfo else {
            XCTFail("City SAT infoi should not be nil")
            return
        }
        guard let url = cityXMLDataInfo.cityHighSchoolSATDataURL else {
            XCTFail("Bad URL for High School's SAT Data XML")
            return
        }
        parseXMLOperation.parseXML(withURL: url)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func parseHighSchoolSATDataFromNetworkCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                 error: ParseHighSchoolDataXMLError?) {
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse A High School's SAT Data from Network XML Expectation should not be nil")
            return
        }
        
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsed A High School's SAT Data from Network")
            expectation.fulfill()
        }
    }

    func testParseCityHighSchoolsSATData() {
        parseHighSchoolDataExpectation = XCTestExpectation(description: "Parse City’s High Schools’ SAT Data XML")
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse City’s High Schools’ SAT Data XML from Networ Expectation should not be nil")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("App delegate should not be nil")
            return
        }
        guard let cityXMLDataInfo = appDelegate.cityHighSchoolsSATDataInfo else {
            XCTFail("City SAT info should not be nil")
            return
        }
        
        let operation = ParseCityHighSchoolsSATDataXMLTask(withCitySATDataInfo: cityXMLDataInfo)
        operation.parse(completionHandler: parseCityHighSchoolsSATDataCompletionHandler)

        wait(for: [expectation], timeout: 10.0)
    }
    
    func parseCityHighSchoolsSATDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                      error: ParseHighSchoolDataXMLError?) {
        guard let expectation = parseHighSchoolDataExpectation else {
            XCTFail("Parse City High School's SAT Data from Network XML Expectation should not be nil")
            return
        }
        
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsed City High School's SAT Data")
            expectation.fulfill()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }    
}
