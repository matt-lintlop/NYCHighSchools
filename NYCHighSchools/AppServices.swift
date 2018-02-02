//
//  AppServices.swift
//  NYCHighSchools
//
//  Created by Matthew Lintlop on 2/1/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import Foundation

//NYC High Schools XML URL:
//https://data.cityofnewyork.us/api/views/s3k6-pzi2/rows.xml?accessType=DOWNLOAD
//
//
//NYC High School SAT Data:
//https://data.cityofnewyork.us/api/views/f9bf-2cp4/rows.xml?accessType=DOWNLOAD

enum AppServiceJSONElements: String {
    case schoolName = "school_name"                                 // high school name
    case numberOfTestTakers = "num_of_sat_test_takers"              // # of test takers
    case averageSATReadingScore = "sat_critical_reading_avg_score"  // average SAT reading score
    case averageSATMathScore = "sat_math_avg_score"                  // average SAT writing score
    case averageSATWritingScore = "sat_writing_avg_score"            // average SAT writing score
}

protocol AppServicesDelegate {
    func didDownloadNYCHighSchoolsData(_ highSchoolsData: [HighSchoolData])
    func errorDownloadNYCHighSchoolsData(_ error: Error)
}

class AppServices : NSObject, XMLParserDelegate {
    var nycHighSchoolsDataList: [HighSchoolData]?                    // list of data for each high school in NYC
    var nycHighSchoolsDataDict: [String:HighSchoolData]?             // dictionary data for each high school in NYC where key = hotl name
    var currentElementName: String?                                 // the name of xml element being parsed
    var parsingHighSchoolNames = false                              // flag = true if parsing high school names
    
    func parseHighSchoolNames(withXMLData xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parsingHighSchoolNames = true
        parser.parse()
        print("# of High Schools  Parsed: \(nycHighSchoolsDataList?.count)")
    }
    
    func parseHighSchoolSATScores(withXMLData xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parsingHighSchoolNames = false
        parser.parse()
    }
    
    // MARK: XML Parsing
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = elementName

        if elementName == AppServiceJSONElements.schoolName.rawValue {
            if parsingHighSchoolNames {
            }
            else {
                // found the name of a high school while parsing SAT data.
                // see if the high school's data exists.
                
                print("FOUND school_name parsing SAT scores")
            }
        }
        else {
            if !parsingHighSchoolNames {
                print("Started elemet named: \(elementName) attributes: \(attributeDict)")
            }
            currentElementName = nil
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if currentElementName == elementName {
            currentElementName = nil
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error parsing: \(parseError)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElementName = self.currentElementName else {
            return
        }
        if parsingHighSchoolNames && (currentElementName == AppServiceJSONElements.schoolName.rawValue) {
            addHighSchoolDataForHighSchoolWithName(string)
        }
        else {
            print("Parser found: \(string) Element: \(currentElementName)")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Finished parsing XML")
    }
    
    // MARK: Utility
    
    func addHighSchoolDataForHighSchoolWithName(_ name: String) {
        // create the high school data class for the high school with the given name
        let highSchoolData = HighSchoolData(name: name)
        if nycHighSchoolsDataList == nil {
            nycHighSchoolsDataList = []
        }
        nycHighSchoolsDataList!.append(highSchoolData)
        print("Added high school data for school with name = \(name)")
        
        // add the high school data to the dictionary for fast lookup by high school name
        if nycHighSchoolsDataDict == nil {
            nycHighSchoolsDataDict = [:]
        }
        nycHighSchoolsDataDict![name] = highSchoolData
    }
    
    func replaceAmpersandInXML(_ xml: String) -> String {
        return xml.replacingOccurrences(of: "&", with: "&amp;")
    }
}
