//
//  AppDelegate.swift
//  sqliteDemo
//
//  Created by tops on 2/17/18.
//  Copyright © 2018 tops. All rights reserved.
//

import UIKit

//step 1 code: copy db file to installation directory

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //B: var for dbpath
    var dbPath:String!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //A:get directory array
        let arrDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        //C:store database path
        self.dbPath = arrDir[0]+"/db.sql"
        
        print("File Path is : \(self.dbPath!)")
        
        //D:check the file is exist or not
        if FileManager.default.fileExists(atPath: self.dbPath)
        {
            print("File is already Exist!")
        }
        else{
            print("Need to copy file!")
            //E: copy file for first time
            let bundleFilePath = Bundle.main.path(forResource: "db", ofType: "sql")
            do{
                try FileManager.default.copyItem(atPath: bundleFilePath!, toPath: self.dbPath)
                
            }
            catch {
                print("Error in copy file:\(error.localizedDescription)")
            }
            
        }
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


}

