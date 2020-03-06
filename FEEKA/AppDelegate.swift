//
//  AppDelegate.swift
//  FEEKA
//
//  Created by Apple Guru on 11/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import OneSignal
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    let googleApiKey = "AIzaSyDKm7yy-RP9WOZmE4-eGPx8EAZTTfPLyw8"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        let userDefault = UserDefaults.standard
        userDefault.setValue(2, forKey: "Gender")
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
        appId: "ec5f0f92-7dd5-4756-b508-63d30ccfd75b",
        handleNotificationAction: nil,
        settings: onesignalInitSettings)
        
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        //gmsplace
        

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
        print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

