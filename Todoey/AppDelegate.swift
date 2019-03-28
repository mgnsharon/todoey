//
//  AppDelegate.swift
//  Todoey
//
//  Created by Megan Sharon on 3/26/19.
//  Copyright © 2019 Megan Sharon. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var realm: Realm?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {
            print(error)
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}

