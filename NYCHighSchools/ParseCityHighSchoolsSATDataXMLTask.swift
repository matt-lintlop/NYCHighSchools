//
//  ParseCityHighSchoolsSATDataXMLTask.swift
//  NYCHighSchools
//
//  Created by Matt Lintlop on 2/12/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

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
    var citySATDataInfo: CityHighSchoolsSATDataInfo                                  // inforation about the city'shigh school  SAT data
    var parseCityHighSchoolDataOperation: ParseCityHighSchoolsDataXMLOperation?      // parse city high school data operation
    var parseCityHighSchoolSATDataOperation: ParseCityHighSchoolsDataXMLOperation?   // parse city high school SAT data operation
    var completionHandler: ParseXMLDataCompletionHandler?                              // copletion handler
    
    init(withCitySATDataInfo citySATDataInfo: CityHighSchoolsSATDataInfo) {
        self.citySATDataInfo = citySATDataInfo
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
        if let url = citySATDataInfo.cityHighSchoolDataURL {
            parseCityHighSchoolsData(with: url)
            
        }
        else if let url = citySATDataInfo.cityOfflineHighSchoolDataURL {
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
    
    func parseCityHighSchoolsSATData() {
        
    }

    func parseCityHighSchoolsDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                   error: ParseHighSchoolDataXMLError?) {
        //
    }
    
    func parseCityHighSchoolsSATDataCompletionHandler(cityHighSchoolsDataDict: [String:HighSchoolData]?,
                                                      error: ParseHighSchoolDataXMLError?) {
        //
    }
}
