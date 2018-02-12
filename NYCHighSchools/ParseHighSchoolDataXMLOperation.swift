//
//  ParseHighSchoolDataXMLOperation.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/11/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit

enum ParseHighSchoolDataXMLError: Error {
    case missingXMLDataError                                // no xml data
    case parseXMLDataError                                  // error parsing xml data
}

// Names of json items from the server.
enum HighSchoolDataJSONItens: String {
    case schoolName = "school_name"                                 // high school name
    case numberOfTestTakers = "num_of_sat_test_takers"              // # of test takers
    case averageSATReadingScore = "sat_critical_reading_avg_score"  // average SAT reading score
    case averageSATMathScore = "sat_math_avg_score"                 // average SAT math score
    case averageSATWritingScore = "sat_writing_avg_score"           // average SAT writing score
    case overViewParagraph = "overview_paragraph"                   // overview paragraph
    case phonNumber = "phone_number"                                // phone number
    case faxNumber = "fax_number"                                   // fax number
    case schoolEmail = "school_email"                               // school email
    case numberOfStudents = "total_students"                        // number of students
    case city = "city"                                              // city
    case zip = "zip"                                                // zip code
    case state = "state_code"                                       // state
    case latitude = "latitude"                                      // latitude
    case longitude = "longitude"                                    // longitude
}

typealias ParseXMLDataCompletionHandler = ([String: HighSchoolData]?, ParseHighSchoolDataXMLError?) -> Void

class ParseHighSchoolDataXMLOperation: Operation, XMLParserDelegate {
    var xmlData: Data?                                          // XML data
    var parseCompletionHandler: ParseXMLDataCompletionHandler   // parse completion handler
    var jsonItemsToParse: [String]                              // list of json items to parse
    var cityHighSchoolsDataDict: [String:HighSchoolData]?       // dictionary data for each high school in the city where key = hotl name
    var currentElementName: String?                             // the name of xml element being parsed
    var currentHighSchoolData: HighSchoolData?                  // current high school data, else nil
    var onlyParseDataForSchoolsInDict: Bool                     // flag = true true if only parsing data for schools in the cityHighSchoolsDataDict
    
    // Designation initializer: Initialize with xml data, a list of JSON items to parse,
    // and a complation handler
    init(xmlDataURL: URL,
         jsonItemsToParse: [String],
         completionHandler:  @escaping ParseXMLDataCompletionHandler,
         cityHighSchoolsDataDict: [String: HighSchoolData]? = nil,
         onlyParseDataForSchoolsInDict: Bool = false) {

        self.jsonItemsToParse = jsonItemsToParse
        self.parseCompletionHandler = completionHandler
        self.cityHighSchoolsDataDict = cityHighSchoolsDataDict
        self.onlyParseDataForSchoolsInDict = onlyParseDataForSchoolsInDict
        if self.cityHighSchoolsDataDict == nil {
            self.cityHighSchoolsDataDict = [:]
        }
        super.init()
        self.loadXMLData(withURL: xmlDataURL)
    }
    
    func loadXMLData(withURL: URL) {
        
    }
         
    func parse() {
        guard let xmlData = self.xmlData else {
            parseCompletionHandler(nil, .missingXMLDataError)
            return
        }
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
        print("# of High Schools  Parsed: \(String(describing: cityHighSchoolsDataDict?.keys.count))")
    }
    
    // MARK: XML Parsing
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseCompletionHandler(nil, .parseXMLDataError)
        print("Error parsing: \(parseError)")
    }
    
    func getHighSchoolData(forSchoolNamed schoolName: String,addIfNotFound: Bool = false) -> HighSchoolData? {
        let uppercasedSchoolName = schoolName.uppercased()
        if self.cityHighSchoolsDataDict == nil {
            self.cityHighSchoolsDataDict = [:]
        }
        if let highSchoolData = self.cityHighSchoolsDataDict![uppercasedSchoolName] {
            return highSchoolData
        }
        else if addIfNotFound {
            let highSchoolData = HighSchoolData(schoolName: schoolName)
            self.cityHighSchoolsDataDict![uppercasedSchoolName] = highSchoolData
            return highSchoolData
        }
        else {
            return nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElementName = self.currentElementName else {
            return
        }
        if currentElementName == HighSchoolDataJSONItens.schoolName.rawValue {
            // A high school's name was found
            self.currentHighSchoolData = self.getHighSchoolData(forSchoolNamed: string,
                                                                addIfNotFound: self.onlyParseDataForSchoolsInDict)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.parseCompletionHandler(self.cityHighSchoolsDataDict, nil)
        parser.delegate = nil
    }
    
    // MARK: Utility
    
    // To fix an error  in NSXMLParser parsing the xml from the server,
    // we need to replace all "&" characters with "&amp"
    func fixAmpersandInXML(_ xml: String) -> String {
        return xml.replacingOccurrences(of: "&", with: "&amp;")
    }

    // MARK: FILE IO
    
    func getXMLData(withFileURL url: URL) -> Data? {
        guard var nycHighSchoolsXMLString = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        nycHighSchoolsXMLString = fixAmpersandInXML(nycHighSchoolsXMLString)
        let nycHighSchoolsXMLData = nycHighSchoolsXMLString.data(using: .utf8)
        return nycHighSchoolsXMLData
    }

  
}
