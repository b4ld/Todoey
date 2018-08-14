//
//  AppDelegate.swift
//  Todoey
//
//  Created by Pedro Carmezim on 01/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        //Path to realm file
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //NewRealm
        do{
            _ = try Realm()
        }catch{
            print("Error creating a new Realm() \(error)")
        }
        
         
        

        return true
    }




}

