//
//  AppDelegate.swift
//  20190131-MattLintlop-NYCSchools
//
//  Created by Matthew Lintlop on 1/29/2019.
//  Copyright © 2019 Matthew Lintlop. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum AppUserDefaultKeys: String {
        case highSchoolDataSortKey = "high_school_data_sort_type"
    }
    
    // Offline NYC High Schools Names XML Filename
    let offlineNewYorkCitySchoolDataXMLFile = "2017-NYC-Schools-Directory"
    
    // Offline NYC High Schools SAT Data XML Filename
    let offlineNewYorkCitySchoolSATDataXMLFile = "2012-NYC-Schools-SAT-Results"
    
    let cityName = "NYC"

    var window: UIWindow?
    var cityHighSchoolsSATDataInfo: CityHighSchoolsSATDataInfo?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // initialize the URLS to the city's data & SAT data
        var offlineCityHighSchoolDataXMLURL: URL?
        var offlineCityHighSchoolSATDataXMLURL: URL?
        if let path = Bundle.main.path(forResource: offlineNewYorkCitySchoolDataXMLFile, ofType: "xml") {
            offlineCityHighSchoolDataXMLURL = URL(fileURLWithPath: path)
        }
        if let path = Bundle.main.path(forResource: offlineNewYorkCitySchoolSATDataXMLFile, ofType: "xml") {
            offlineCityHighSchoolSATDataXMLURL = URL(fileURLWithPath: path)
        }
        cityHighSchoolsSATDataInfo = CityHighSchoolsSATDataInfo(city: cityName,
                                                                cityOfflineHighSchoolDataURL: offlineCityHighSchoolDataXMLURL,
                                                                cityOfflineHighSchoolSATDataURL: offlineCityHighSchoolSATDataXMLURL)
        
        // Application tintColor
        window?.tintColor = UIColor.white

        // Navigation bar background color
        UINavigationBar.appearance().barTintColor = UIColor.blue

        // Make the text in the navigation bar white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
 
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        window?.rootViewController?.beginAppearanceTransition(false, animated: false)
        window?.rootViewController?.endAppearanceTransition()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        window?.rootViewController?.beginAppearanceTransition(true, animated: false)
        window?.rootViewController?.endAppearanceTransition()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func offlineCityHighSchoolDataURL() -> URL? {
        return URL(fileURLWithPath: offlineNewYorkCitySchoolDataXMLFile)
    }

    func offlineCityHighSchoolSATDataURL() -> URL? {
        return URL(fileURLWithPath: offlineNewYorkCitySchoolSATDataXMLFile)
    }
    
    // MARK: Settings
    
    func getHighSchoolDataSortType() -> HighSchoolDataSortType {
        if let sortDataType = UserDefaults().string(forKey:AppUserDefaultKeys.highSchoolDataSortKey.rawValue) {
            
            switch sortDataType {
            case HighSchoolDataSortType.highSchoolName.rawValue:
                return .highSchoolName

            case HighSchoolDataSortType.bestAvgMathSATScore.rawValue:
                return .bestAvgMathSATScore
                
            case HighSchoolDataSortType.bestAvgReadingSATScore.rawValue:
                return .bestAvgReadingSATScore
                
            case HighSchoolDataSortType.bestAvgWritingSATScore.rawValue:
                return .bestAvgWritingSATScore
                
            case HighSchoolDataSortType.maxNumberOfSATTestTakers.rawValue:
                return .maxNumberOfSATTestTakers
                
            case HighSchoolDataSortType.maxNumberOfStudents.rawValue:
                return .maxNumberOfStudents
                
             default:
                setHighSchoolDataSortType(.highSchoolName)
                return .highSchoolName
                
            }
        }
        else {
            setHighSchoolDataSortType(.highSchoolName)
            return .highSchoolName

        }
    }
    
    func setHighSchoolDataSortType(_ dataSortType: HighSchoolDataSortType) {
        UserDefaults().setValue(dataSortType.rawValue, forKeyPath: AppUserDefaultKeys.highSchoolDataSortKey.rawValue)
        NotificationCenter.default.post(name: didSetSetHighSchoolDataSortTypeNotification, object: dataSortType)
    }
}

