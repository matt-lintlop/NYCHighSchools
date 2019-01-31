//
//  ParseCityHighSchoolsSATDataXMLTask.swift
//  20190131-MattLintlop-NYCSchools
//
//  Created by Matt Lintlop on 1/31/2019.
//  Copyright © 2019 Matthew Lintlop. All rights reserved.
//

// City high school SAT data information
struct CityHighSchoolsSATDataInfo {
    var city: String                                    // name of city for showing SAT data
    var cityOfflineHighSchoolDataURL: URL?              // url of offline city high school data xml
    var cityOfflineHighSchoolSATDataURL: URL?           // url of offline city high school SAT data xml
}
import UIKit

class ParseCityHighSchoolsSATDataXMLTask {
    var citySATDataInfo: CityHighSchoolsSATDataInfo                                 // inforation about the city'shigh school  SAT data
    var parseCityHighSchoolDataOperation: ParseCityHighSchoolsDataXMLOperation?     // parse city high school data operation
    var parseCityHighSchoolSATDataOperation: ParseCityHighSchoolsDataXMLOperation?  // parse city high school SAT data operation
    var completionHandler: ParseXMLDataCompletionHandler?                           // copletion handler
    var hasNetwork: Bool = false                                                    // network available flag
    var cityHighSchoolsDataDict: [String:HighSchoolData]?                           // city high schools data dictionary has data about every high school in city
    var useOfflineData = false                                                      // trie if network error and offline data should be used

    init(withCitySATDataInfo citySATDataInfo: CityHighSchoolsSATDataInfo) {
        self.citySATDataInfo = citySATDataInfo
        self.hasNetwork = false
        self.hasNetwork = checkForNetwork()
    }
    
    deinit {
        parseCityHighSchoolDataOperation?.cancel()
        parseCityHighSchoolDataOperation?.cancel()
    }
    
    func parse(completionHandler:  @escaping ParseXMLDataCompletionHandler) {
        self.completionHandler = completionHandler
        parseCityHighSchoolsData()
    }
    
    func parseCityHighSchoolsData() {
        if let url = citySATDataInfo.cityOfflineHighSchoolDataURL {
            parseCityHighSchoolsData(with: url)
        }
        else {
            completionHandler?(nil, .noXMLDataError)
        }
    }
    
    func parseCityHighSchoolsData(with url: URL) {
        let jsonItemToParse: [String] = [HighSchoolDataJSONItens.schoolName.rawValue,
        HighSchoolDataJSONItens.overViewParagraph.rawValue,
        HighSchoolDataJSONItens.phonNumber.rawValue,
        HighSchoolDataJSONItens.faxNumber.rawValue,
        HighSchoolDataJSONItens.schoolEmail.rawValue,
        HighSchoolDataJSONItens.primaryAddress.rawValue,
        HighSchoolDataJSONItens.numberOfStudents.rawValue,
        HighSchoolDataJSONItens.city.rawValue,
        HighSchoolDataJSONItens.zip.rawValue,
        HighSchoolDataJSONItens.state.rawValue,
        HighSchoolDataJSONItens.latitude.rawValue,
        HighSchoolDataJSONItens.longitude.rawValue]
    
        let parseXMLOperation = ParseCityHighSchoolsDataXMLOperation(jsonItemsToParse: jsonItemToParse,
                                                                     completionHandler: parseCityHighSchoolsDataCompletionHandler,
                                                                     cityHighSchoolsDataDict: nil,
                                                                     addAllParsedItems: true)
        parseXMLOperation.parseXML(withURL: url)
    }
    
    func checkForNetwork() -> Bool {
        guard let url = URL(string:"https://data.cityofnewyork.us/api/views/s3k6-pzi2") else {
            return false
        }
        guard let hostName = url.host else {
            return false
        }
        guard let myNetwork = Reachability(hostName: hostName) else {
            return false
        }
        let myStatus: NetworkStatus = myNetwork.currentReachabilityStatus()

        switch myStatus {
        case .NotReachable:
            print("There's no internet connection at all. Display error message now.");
            return false

        case .ReachableViaWWAN:
            print("We have a 3G connection");
            return true

        case .ReachableViaWiFi:
            print("We have WiFi.");
            return true
        }
    }
    
    func cancel() {
        parseCityHighSchoolDataOperation?.cancel()
        parseCityHighSchoolSATDataOperation?.cancel()
    }
    
    func parseCityHighSchoolsSATData() {
        if let url = citySATDataInfo.cityOfflineHighSchoolSATDataURL {
            parseCityHighSchoolsSATData(with: url)
        }
        else {
            completionHandler?(nil, .noXMLDataError)
        }
    }

    func parseCityHighSchoolsSATData(with url: URL) {
        let jsonItemToParse: [String] = [HighSchoolDataJSONItens.schoolName.rawValue,
                                         HighSchoolDataJSONItens.averageSATMathScore.rawValue,
                                         HighSchoolDataJSONItens.averageSATReadingScore.rawValue,
                                         HighSchoolDataJSONItens.averageSATWritingScore.rawValue,
                                         HighSchoolDataJSONItens.numberOfTestTakers.rawValue]

        let parseXMLOperation = ParseCityHighSchoolsDataXMLOperation(jsonItemsToParse: jsonItemToParse,
                                                                     completionHandler: parseCityHighSchoolsSATDataCompletionHandler,
                                                                     cityHighSchoolsDataDict: self.cityHighSchoolsDataDict,
                                                                     addAllParsedItems: false)
        parseXMLOperation.parseXML(withURL: url)
    }
    
    func parseCityHighSchoolsDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                   error: ParseHighSchoolDataXMLError?) {
  
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            if cityHighSchoolsDataDict?.count == 0 {
                print("Forcing Loading offlead data!")
                self.useOfflineData = true
                self.parseCityHighSchoolsData()
                return
            }
            print("SUCCESS! Parsing City High School Data")
            self.cityHighSchoolsDataDict = cityHighSchoolsDataDict
            parseCityHighSchoolsSATData()

         }
        else {
            print("Error Parsing City High School Data")
            completionHandler?(nil, error)
        }
    }
    
    func parseCityHighSchoolsSATDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                      error: ParseHighSchoolDataXMLError?) {
        
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsing City High School SAT Data")
            completionHandler?(cityHighSchoolsDataDict, error)
        }
        else {
            print("Error Parsing City High School SAT Data")
            completionHandler?(nil, error)
        }
    }

}
