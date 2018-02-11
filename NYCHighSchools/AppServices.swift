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
    func didParseNYCHighSchoolsNamesData(_ highSchoolsData: [HighSchoolData])
    func didParseNYCHighSchoolsSATScoresData(_ highSchoolsData: [HighSchoolData])
    func errorParsingNYCHighSchoolsData(_ error: Error)
}

class AppServices : NSObject, XMLParserDelegate {
    var nycHighSchoolsDataList: [HighSchoolData]?                    // list of data for each high school in NYC
    var nycHighSchoolsDataDict: [String:HighSchoolData]?             // dictionary data for each high school in NYC where key = hotl name
    var currentElementName: String?                                 // the name of xml element being parsed
    var parsingHighSchoolNames = false                              // flag = true if parsing high school names
    var delegate: AppServicesDelegate?                              // app services delegate
    var currentHighSchoolData: HighSchoolData?                      // current NYC high school data, else nil
    
    func parseHighSchoolNames(withXMLData xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parsingHighSchoolNames = true
        parser.parse()
        print("# of High Schools  Parsed: \(String(describing: nycHighSchoolsDataList?.count))")
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
   }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        delegate?.errorParsingNYCHighSchoolsData(parseError)
        print("Error parsing: \(parseError)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElementName = self.currentElementName else {
            return
        }
        if currentElementName == AppServiceJSONElements.schoolName.rawValue {
            if parsingHighSchoolNames {
                addHighSchoolDataForHighSchoolWithName(string)
            }
            else {
                // found a high school name while parsing SAT data
                currentHighSchoolData = nycHighSchoolsDataDict?[string]
                if currentHighSchoolData != nil {
                    print("Found High School for SAT data parsing: \(string)")
                }
                else {
                    print("Missing High School for SAT data parsing: \(string)")
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if parsingHighSchoolNames {
            delegate?.didParseNYCHighSchoolsNamesData(nycHighSchoolsDataList!)
            print("Finished parsing NYC High School Names XML")
        }
        else {
            delegate?.didParseNYCHighSchoolsSATScoresData(nycHighSchoolsDataList!)
            print("Finished parsing NYC High School SAT Scores XML")
        }
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
        nycHighSchoolsDataDict![name.uppercased()] = highSchoolData
    }
    
    func replaceAmpersandInXML(_ xml: String) -> String {
        return xml.replacingOccurrences(of: "&", with: "&amp;")
    }
    
    // MARK: Offline Storage
//    func load_Offline_NYC_HighSchools_XML_Data() -> Data? {
//        guard let path = Bundle.main.path(forResource: "NYC_2017_High_Schools_Names", ofType: "xml") else {
//            return nil
//        }
//        let url = URL(fileURLWithPath: path)
//        
//        guard var nycHighSchoolsXMLString = try? String(contentsOf: url, encoding: .utf8) else {
//            return nil
//        }
//        nycHighSchoolsXMLString = replaceAmpersandInXML(nycHighSchoolsXMLString)
//        
//        let nycHighSchoolsXMLData = nycHighSchoolsXMLString.data(using: .utf8)
//        return nycHighSchoolsXMLData
//    }
//    
//   func load_Offline_NYC_HighSchools_SAT_XML_Data() -> Data? {
//        guard let path = Bundle.main.path(forResource: "NYC_2017_High_Schools_SAT_Data", ofType: "xml") else {
//            return nil
//        }
//        let url = URL(fileURLWithPath: path)
//        guard var nycHighSchoolsSATDataXMLString = try? String(contentsOf: url, encoding: .utf8) else {
//            return nil
//        }
//        nycHighSchoolsSATDataXMLString = replaceAmpersandInXML(nycHighSchoolsSATDataXMLString)
//        let nycSATXMLData = nycHighSchoolsSATDataXMLString.data(using: .utf8)
//        return nycSATXMLData
//    }
//    
    
    func load_Offline_NYC_HighSchools_XML_Data() -> Data? {
        guard let path = Bundle.main.path(forResource: "NYC_2017_High_Schools_Names", ofType: "xml") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        
        guard var nycHighSchoolsXMLString = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        nycHighSchoolsXMLString = replaceAmpersandInXML(nycHighSchoolsXMLString)
        
        let nycHighSchoolsXMLData = nycHighSchoolsXMLString.data(using: .utf8)
        return nycHighSchoolsXMLData
    }
    
    func load_Offline_NYC_HighSchools_SAT_XML_Data() -> Data? {
        guard let path = Bundle.main.path(forResource: "NYC_2017_High_Schools_SAT_Data", ofType: "xml") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard var nycHighSchoolsSATDataXMLString = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        nycHighSchoolsSATDataXMLString = replaceAmpersandInXML(nycHighSchoolsSATDataXMLString)
        let nycSATXMLData = nycHighSchoolsSATDataXMLString.data(using: .utf8)
        return nycSATXMLData
    }

}
