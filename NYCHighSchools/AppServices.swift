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


class AppServices : NSObject, XMLParserDelegate {
    var nycHighScoolsData: [HighSchoolData] = []        // data for each high school in NYC
    var currentElementName: String?                     // the name of xml element being parsed
    
    func parseHighSchoolNames(withXMLData xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
    }
    
    func parseHighSchoolSATScores(withXMLData xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: XML Parsing
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "school_name" {
            currentElementName = elementName
 //           print("Started elemet named: \(elementName) attributes: \(attributeDict)")
        }
        else {
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
        print("Parser found: \(string) Element: \(currentElementName)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Finished parsing XML")
    }
    
    // MARK: Utility
    
    func replaceAmpersandInXML(_ xml: String) -> String {
        return xml.replacingOccurrences(of: "&", with: "&amp;")
    }
}
