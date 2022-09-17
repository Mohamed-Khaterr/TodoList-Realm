//
//  AppDelegate.swift
//  TodoList-Realm
//
//  Created by Khater on 9/15/22.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            
            _ = try Realm()
            
        } catch {
            print("Error initializing Realm: \(error)")
        }
        
        // To get Realm File
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }
}

