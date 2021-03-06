////
////  AppDelegate.swift
////  Lou's App
////
////  Created by 林翌埕 on 2016/3/14.
////  Copyright (c) 2016年 KanStudio. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//
//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }
//
//    func applicationWillResignActive(application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(application: UIApplication) {
//        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        // Saves changes in the application's managed object context before the application terminates.
////        self.saveContext()
//    }
//
//    // MARK: - Core Data stack
//
////    lazy var applicationDocumentsDirectory: NSURL = {
////        // The directory the application uses to store the Core Data store file. This code uses a directory named "KanStudio.Lou_s_App" in the application's documents Application Support directory.
////        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
////        return urls[urls.count-1]
////    }()
////
////    lazy var managedObjectModel: NSManagedObjectModel = {
////        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
////        let modelURL = NSBundle.mainBundle().URLForResource("Lou_s_App", withExtension: "momd")!
////        return NSManagedObjectModel(contentsOfURL: modelURL)!
////    }()
////
////    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
////        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
////        // Create the coordinator and store
////        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
////        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Lou_s_App.sqlite")
////        var error: NSError? = nil
////        var failureReason = "There was an error creating or loading the application's saved data."
////        do {
////            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
////        } catch let error as NSError {
////            print(error.localizedDescription)
////
////        }
////
////        return coordinator
////    }()
////
////    lazy var managedObjectContext: NSManagedObjectContext? = {
////        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
////        let coordinator = self.persistentStoreCoordinator
////        if coordinator == nil {
////            return nil
////        }
////        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
////        managedObjectContext.persistentStoreCoordinator = coordinator
////        return managedObjectContext
////    }()
////
////    // MARK: - Core Data Saving support
////
////    func saveContext () {
////        do {
////            try managedObjectContext!.save()
////        } catch let error {
////            print("Could not cache the response \(error)")
////        }
////    }
//}
//

//
//  AppDelegate.swift
//  FontGallery
//
//  Created by Yi-Cheng Lin on 2019/10/30.
//  Copyright © 2019 Yi-Cheng Lin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		
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
