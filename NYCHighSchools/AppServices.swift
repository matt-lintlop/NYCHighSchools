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
        print("Started elemet named: \(elementName) attributes: \(attributeDict)")
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Finished parsing XML")
    }
}
