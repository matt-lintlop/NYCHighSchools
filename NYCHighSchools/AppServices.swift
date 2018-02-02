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
    case schoolNameElement = "school_name"
}

class AppServices : NSObject, XMLParserDelegate {
    var nycHighScoolsData: [HighSchoolData] = []        // data for each high school in NYC
    var currentElementName: String?                     // the name of xml element being parsed
    var parsingHighSchoolNames = false                  // flag = true if parsing high school names
    
    func parseHighSchoolNames(withXMLData xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parsingHighSchoolNames = true
        parser.parse()
        print("# of High Schools Data Parsed: \(nycHighScoolsData.count)")
    }
    
    func parseHighSchoolSATScores(withXMLData xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parsingHighSchoolNames = false
        parser.parse()
    }
    
    // MARK: XML Parsing
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if parsingHighSchoolNames && (elementName == AppServiceJSONElements.schoolNameElement.rawValue) {
            currentElementName = elementName
        }
        else {
 //          print("Started elemet named: \(elementName) attributes: \(attributeDict)")
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
        if parsingHighSchoolNames && (currentElementName == AppServiceJSONElements.schoolNameElement.rawValue) {
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
        let highSchoolData = HighSchoolData(name: name)
        nycHighScoolsData.append(highSchoolData)
        print("Added high school data for school with name = \(name)")
    }
    
    func replaceAmpersandInXML(_ xml: String) -> String {
        return xml.replacingOccurrences(of: "&", with: "&amp;")
    }
}
