//
//  AppDelegate.swift
//  NYCHighSchools
//
//  Created by Matthew Lintlop on 2/1/18.
//  Copyright © 2018 Matthew Lintlop. All rights reserved.
//

import UIKit

// URL of NYC High Schools Names XML
let newYorkCitySchoolDataXMLPath = "https://data.cityofnewyork.us/api/views/s3k6-pzi2/rows.xml?accessType=DOWNLOAD"

// Offline NYC High Schools Names XML Filename
let offlineNewYorkCitySchoolDataXMLFile = "NYC_2017_High_Schools_Names"

// URL of NYC High Schools SAT Data XML
let newYorkCitySchoolSATDataXMLPath = "https://data.cityofnewyork.us/api/views/f9bf-2cp4/rows.xml?accessType=DOWNLOAD"

// Offline NYC High Schools SAT Data XML Filename
let offlineNewYorkCitySchoolSATDataXMLFile = "NYC_2017_High_Schools_SAT_Data"

let cityName = "NYC"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
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

}

