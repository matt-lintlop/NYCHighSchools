//
//  ParseCityHighSchoolsSATDataXMLTask.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/12/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

// URL of NYC High Schools Names XML
let newYorkCitySchoolDataXMLPath = "https://data.cityofnewyork.us/api/views/s3k6-pzi2/rows.xml?accessType=DOWNLOAD"

// Offline NYC High Schools Names XML Filename
let offlineNewYorkCitySchoolDataXMLFile = "NYC_2017_High_Schools_Names"

// URL of NYC High Schools SAT Data XML
let newYorkCitySchoolSATDataXMLPath = "https://data.cityofnewyork.us/api/views/f9bf-2cp4/rows.xml?accessType=DOWNLOAD"

// Offline NYC High Schools SAT Data XML Filename
let offlineNewYorkCitySchoolSATDataXMLFile = "NYC_2017_High_Schools_SAT_Data"

let cityName = "NYC"

// City high school SAT data information
struct CityHighSchoolsSATDataInfo {
    var city: String                                    // name of city for showing SAT data
    var cityOfflineHighSchoolDataURL: URL?              // url of offline city high school data xml
    var cityOfflineHighSchoolSATDataURL: URL?           // url of offline city high school SAT data xml
    var cityHighSchoolDataURL: URL?                     // url of city high school data xml
    var cityHighSchoolSATDataURL: URL?                  // url of city high school SAT data xml
}
import UIKit

class ParseCityHighSchoolsSATDataXMLTask {
    var citySATDataInfo: CityHighSchoolsSATDataInfo                                 // inforation about the city'shigh school  SAT data
    var parseCityHighSchoolDataOperation: ParseCityHighSchoolsDataXMLOperation?     // parse city high school data operation
    var parseCityHighSchoolSATDataOperation: ParseCityHighSchoolsDataXMLOperation?  // parse city high school SAT data operation
    var completionHandler: ParseXMLDataCompletionHandler?                           // copletion handler
    var hasNetwork: Bool = false                                                    // network available flag
    
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
        if hasNetwork {
            if let url = citySATDataInfo.cityHighSchoolDataURL {
                parseCityHighSchoolsData(with: url)
                return
            }
        }
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
        guard let url = URL(string: newYorkCitySchoolDataXMLPath) else {
            return
        }
        parseXMLOperation.parseXML(withURL: url)
    }
    
    func checkForNetwork() -> Bool {
        guard let url = citySATDataInfo.cityHighSchoolDataURL else {
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
    
    func parseCityHighSchoolsSATData() {
        if hasNetwork {
            if let url = citySATDataInfo.cityHighSchoolSATDataURL {
                parseCityHighSchoolsSATData(with: url)
                return
            }
        }
        if let url = citySATDataInfo.cityOfflineHighSchoolSATDataURL {
            parseCityHighSchoolsSATData(with: url)
        }
        else {
            completionHandler?(nil, .noXMLDataError)
        }
    }

    func parseCityHighSchoolsSATData(with url: URL) {
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
                                                                 completionHandler: parseCityHighSchoolsSATDataCompletionHandler,
                                                                 cityHighSchoolsDataDict: nil,
                                                                 addAllParsedItems: true)
    guard let url = URL(string: newYorkCitySchoolDataXMLPath) else {
        return
    }
    parseXMLOperation.parseXML(withURL: url)
}

    func parseCityHighSchoolsDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                   error: ParseHighSchoolDataXMLError?) {
        if (cityHighSchoolsDataDict != nil) && (error == nil) {
            print("SUCCESS! Parsing City High School Data")
            completionHandler?(cityHighSchoolsDataDict, error)
        }
        else {
            print("Error Parsing City High School Data")
            completionHandler?(nil, error)
        }
    }
    
    func parseCityHighSchoolsSATDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                      error: ParseHighSchoolDataXMLError?) {
        //
    }
}
