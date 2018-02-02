//
//  AppServices.swift
//  NYCHighSchools
//
//  Created by Matthew Lintlop on 2/1/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import Foundation

class AppServices : NSObject, XMLParserDelegate {
    var nycHighScoolsData: [HighSchoolData] = []        // data for each high school in NYC
    
    func parseHighSchoolNamesInNYC() {
        
    }
    
    func parseHighSchoolSATScoresInNYC() {
        
    }
    
    // MARK: XML Parsing
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("Started elemet named: \(elementName) attributes: \(attributeDict)")
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Finished parsing XML")
    }
}
