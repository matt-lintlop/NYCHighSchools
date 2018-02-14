//
//  ParseCityHighSchoolsDataXMLOperation
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/11/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit

enum ParseHighSchoolDataXMLError: Error {
    case noXMLDataError                     // no xml data error
    case parseXMLDataError                  // error parsing xml data
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

class ParseCityHighSchoolsDataXMLOperation: Operation, XMLParserDelegate {
    var downloadXMLDataTask: URLSessionDataTask?                // Download XML Data task
    var xmlData: Data?                                          // XML data
    var xmlDataURL: URL?                                        // XML data URL
    var currentHighSchoolName: String?                          // Current High School Name
    var completionHandler: ParseXMLDataCompletionHandler?       // parse xml data completion handler
    var jsonItemsToParse: [String]?                             // list of json items to parse
    var cityHighSchoolsDataDict: [String:HighSchoolData]?       // dictionary data for each high school in the city where key = hotl name
    var currentElementName: String?                             // the name of xml element being parsed
    var currentHighSchoolData: HighSchoolData?                  // current high school data, else nil
    var addAllParsedItems: Bool                                 // flag = true if all parsed data is added or false if ony for schools in dictionary
    
    static var queue = OperationQueue()                         // parse xml operation qieie
    
    // Designation initializer: Initialize with xml data, a list of JSON items to parse,
    // and a complation handler
    init(jsonItemsToParse: [String],
         completionHandler:  @escaping ParseXMLDataCompletionHandler,
         cityHighSchoolsDataDict: [String: HighSchoolData]? = nil,
         addAllParsedItems: Bool = true) {
        
        self.jsonItemsToParse = jsonItemsToParse
        self.completionHandler = completionHandler
        self.cityHighSchoolsDataDict = cityHighSchoolsDataDict
        self.currentHighSchoolData = nil
        self.currentHighSchoolName = nil
        self.addAllParsedItems = addAllParsedItems
        if self.cityHighSchoolsDataDict == nil {
            self.cityHighSchoolsDataDict = [:]
        }
        super.init()
    }
    
    deinit {
        completionHandler = nil
    }
    
    // MARK: XML Parsing
    
    func parseXML(withURL url: URL) {
        self.xmlDataURL = url
        ParseCityHighSchoolsDataXMLOperation.queue.addOperation(self)
    }
 
    func parseXML(withData data: Data) {
        self.xmlData = data
        self.currentHighSchoolData = nil
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    // MAR: XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        guard let jsonItems = jsonItemsToParse, jsonItems.contains(elementName) else {
            currentElementName = nil
            return
        }
        currentElementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
         currentElementName = nil
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.completionHandler?(nil, .parseXMLDataError)
        print(">> Parser Error: \(parseError)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElementName = self.currentElementName else {
            return
        }
        if currentElementName == HighSchoolDataJSONItens.schoolName.rawValue {
            
            // validate the school name
            guard let schoolName = removeSpecialCharsFromSchoolName(string) else {
                return
            }
        
            // A high school's name was found
            self.currentHighSchoolName = schoolName
            self.currentHighSchoolData = self.getHighSchoolData(forSchoolNamed: schoolName,
                                                                addIfNotFound: self.addAllParsedItems)
            if self.addAllParsedItems && (self.currentHighSchoolData == nil) {
                self.completionHandler?(nil, .parseXMLDataError)
                return
            }
        }
        else {
            if self.addAllParsedItems {
                // add data for every high school parsed
                guard currentHighSchoolData != nil else {
                    self.completionHandler?(nil, .parseXMLDataError)
                    return
                }
            }
            else {
                // don't add data for high schools not found in
                // the dictionary that was passed to this operation's init.
                if currentHighSchoolData == nil {
                    return
                }
            }
                
            guard let highSchoolData = self.currentHighSchoolData else {
                self.completionHandler?(nil, .parseXMLDataError)
                return
            }
            switch currentElementName {
                case HighSchoolDataJSONItens.city.rawValue:
                    highSchoolData.city = string
                case HighSchoolDataJSONItens.zip.rawValue:
                    highSchoolData.zip = string
                case HighSchoolDataJSONItens.state.rawValue:
                    highSchoolData.state = string
                case HighSchoolDataJSONItens.latitude.rawValue:
                    highSchoolData.latitude = Float(string)
                case HighSchoolDataJSONItens.longitude.rawValue:
                    highSchoolData.longitude = Float(string)
                case HighSchoolDataJSONItens.numberOfTestTakers.rawValue:
                    highSchoolData.numberOfSATTestTakers = Int(string)
                case HighSchoolDataJSONItens.averageSATReadingScore.rawValue:
                    highSchoolData.averageSATReadingScore = Float(string)
                case HighSchoolDataJSONItens.averageSATMathScore.rawValue:
                    highSchoolData.averageSATMathScore = Float(string)
                case HighSchoolDataJSONItens.averageSATWritingScore.rawValue:
                    highSchoolData.averageSATWritingScore = Float(string)
                case HighSchoolDataJSONItens.overViewParagraph.rawValue:
                    highSchoolData.overViewParagraph = string
                case HighSchoolDataJSONItens.phonNumber.rawValue:
                    highSchoolData.phonNumber = string
                case HighSchoolDataJSONItens.faxNumber.rawValue:
                    highSchoolData.faxNumber = string
                case HighSchoolDataJSONItens.schoolEmail.rawValue:
                    highSchoolData.schoolEmail = string
                case HighSchoolDataJSONItens.numberOfStudents.rawValue:
                    highSchoolData.numberOfStudents = Int(string)
                default:
                    print("Skipped parsing element named: \(currentElementName)")
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        guard let cityHighSchoolsDataDict = self.cityHighSchoolsDataDict else {
            self.completionHandler?(nil, .parseXMLDataError)
            return
        }
        self.completionHandler?(cityHighSchoolsDataDict, nil)
        parser.delegate = nil
    }
    
    // MARK: Utility
    
    func getHighSchoolData(forSchoolNamed schoolName: String,addIfNotFound: Bool = false) -> HighSchoolData? {
        guard let schoolName = removeSpecialCharsFromSchoolName(schoolName) else {
            return nil
        }
        let uppercasedSchoolName = schoolName.uppercased()
        if let highSchoolData = self.cityHighSchoolsDataDict?[uppercasedSchoolName] {
            return highSchoolData
        }
        else if addIfNotFound {
           if self.cityHighSchoolsDataDict == nil {
                self.cityHighSchoolsDataDict = [:]
            }
            let highSchoolData = HighSchoolData(schoolName: schoolName)
            self.cityHighSchoolsDataDict![uppercasedSchoolName] = highSchoolData
            return highSchoolData
        }
        else {
            return nil
        }
    }

    // To fix an error  in NSXMLParser parsing the xml from the server,
    // we need to replace all "&" characters with "&amp"
    func fixAmpersandInXML(_ xml: String) -> String {
        return xml.replacingOccurrences(of: "&", with: "&amp;")
    }
 
    // MARK: FILE IO
    
    func downloadXMLData(withURL url: URL) {
        print("Downloading data from url: \(url.absoluteString)")
        self.xmlDataURL = url
        if url.isFileURL {
            // load the xml data from a file
            loadXMLData(withFileURL: url)
        }
        else {
            // load the xml data from the network
            downloadXMLDataTask = URLSession.shared.dataTask(with: url,
                                                             completionHandler:downloadXMLDataCompletionHandler)
            downloadXMLDataTask?.resume()
        }
    }
    
    override func cancel() {
        super.cancel()
        
        if let dataTask = downloadXMLDataTask {
            dataTask.cancel()
            print("Canceled Download of URL: \(String(describing: xmlDataURL?.absoluteString))")
        }
    }
    
    func downloadXMLDataCompletionHandler(data: Data?, response: URLResponse?, error: Error?) {
        
        downloadXMLDataTask = nil

        if let _ = error {
            completionHandler?(nil, .noXMLDataError)
        }
        else {
            if let data = data {
                parseXML(withData: data)
            }
            else {
                completionHandler?(nil, .noXMLDataError)
            }
        }
    }
    
    func loadXMLData(withFileURL url: URL) {
        guard url.isFileURL else {
            completionHandler?(nil, .noXMLDataError)
            return
        }
        guard var xmlString = try? String(contentsOf: url, encoding: .utf8) else {
            completionHandler?(nil, .noXMLDataError)
            return
        }
        xmlString = fixAmpersandInXML(xmlString)
        let data = xmlString.data(using: .utf8)
        if data == nil {
            completionHandler?(nil, .noXMLDataError)
        }
        else {
            parseXML(withData: data!)
        }
    }

    func getXMLData(withFileURL url: URL) -> Data? {
        guard var nycHighSchoolsXMLString = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        nycHighSchoolsXMLString = fixAmpersandInXML(nycHighSchoolsXMLString)
        let nycHighSchoolsXMLData = nycHighSchoolsXMLString.data(using: .utf8)
        return nycHighSchoolsXMLData
    }
    
    override func main() {
        if !isCancelled {
            guard let xmlDataURL = xmlDataURL else {
                return
            }
            downloadXMLData(withURL: xmlDataURL)
        }
        else {
            completionHandler?(nil, .noXMLDataError)
        }
     }

}
