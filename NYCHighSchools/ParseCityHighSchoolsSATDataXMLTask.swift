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
            
        }
        else if let url = citySATDataInfo.cityOfflineHighSchoolDataURL {
            
        }
        else {
            completionHandler?(nil, .noXMLDataError)
        }
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
