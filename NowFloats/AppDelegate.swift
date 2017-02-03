//
//  AppDelegate.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/17/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight
import MobileCoreServices
import MagicalRecord
import Fabric
import Crashlytics
import FacebookCore
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UITabBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        UITabBar.appearance().backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        self.setUpMagicalDB()
        self.configure()
        
        if UserDefaults.standard.value(forKey: "USER_ID") == nil{
            AppEventsLogger.log("App Launched")
        }else{
            CXFBEvents.sharedInstance.logAppLaunchedEvent(_eventName: "App Launched", UserDefaults.standard.value(forKey: "USER_EMAIL")! as! String)
        }
        
        //MARK: Mixpanel Integration
        CXMixpanel.sharedInstance.registerMixpanelFrameWorkWithApiKey()
        
        
        return true
    }
    
    func blockOperationsTest1(){
        
        let operationQueue = OperationQueue()
        
        let operation1 : BlockOperation = BlockOperation (block: {
            self.doCalculations()
            
            let operation2 : BlockOperation = BlockOperation (block: {
                
                self.doSomeMoreCalculations()
                
            })
            operationQueue.addOperation(operation2)
        })
        operationQueue.addOperation(operation1)
    }
    
    func doCalculations(){
        NSLog("do Calculations")
        for i in 100...105{
            print("i in do calculations is \(i)")
            sleep(1)
        }
    }
    
    func doSomeMoreCalculations(){
        NSLog("do Some More Calculations")
        for j in 1...5{
            print("j in do some more calculations is \(j)")
            sleep(1)
        }
        
    }
    
    //MARK: Sidepanel setup
    func setUpSidePanelview(){
        
        /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         
         
         
         let homeView = storyBoard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
         
         let menuVC = storyBoard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
         //        let menuVC = storyBoard.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
         
         
         let navHome = UINavigationController(rootViewController: menuVC)
         let revealVC = SWRevealViewController(rearViewController: homeView, frontViewController: navHome)
         revealVC.delegate = self
         revealVC.rearViewRevealWidth = CXAppConfig.sharedInstance.mainScreenSize().width-50
         self.window?.rootViewController = revealVC
         self.window?.makeKeyAndVisible()*/
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEventsLogger.activate(application)
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let isHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
        return isHandled
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if userActivity.activityType == CSSearchableItemActionType{
            
            let identifier = userActivity.userInfo![CSSearchableItemActivityIdentifier] as! String
            
            let productEn = NSEntityDescription.entity(forEntityName: "CX_Products", in: NSManagedObjectContext.mr_contextForCurrentThread())
            let predicate:NSPredicate =  NSPredicate(format: "pid == %@",identifier)
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CX_Products.mr_requestAllSorted(by: "pid", ascending: true)
            fetchRequest.predicate = predicate
            fetchRequest.entity = productEn
            let productArr = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray
            
            let storesEntity : CX_Products = productArr.lastObject as! CX_Products
            
            let productDic = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
            let productString = CXConstant.sharedInstance.convertDictionayToString(productDic)
            print(productDic)
            
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            //Trimming Price And Discount
            let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: storesEntity.json!))!
            let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
            
            let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: storesEntity.json!))!
            let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
            
            //FinalPrice after subtracting the discount
            let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
            let FinalPrice = String(finalPriceNum) as String
            
            
            let productDetails = storyBoard.instantiateViewController(withIdentifier: "PRODUCT_DETAILS") as! ProductDetailsViewController
            productDetails.productString = productString as String
            
            let rootViewController = self.window!.rootViewController as! UINavigationController
            rootViewController.pushViewController(productDetails, animated: true)
            
        }
        return true
    }
    
    // MARK: - Core Data stack
    
    func setUpMagicalDB() {
        //MagicalRecord.setupCoreDataStackWithStoreNamed("Silly_Monks")
        NSPersistentStoreCoordinator.mr_setDefaultStoreCoordinator(persistentStoreCoordinator)
        NSManagedObjectContext.mr_initializeDefaultContext(with: persistentStoreCoordinator)
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.CX.NowFloats" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "NowFloats", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        print(url)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        print(managedObjectContext.hasChanges)
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: Loader configuration
    
    func configure (){
        var config : LoadingView.Config = LoadingView.Config()
        config.size = 100
        config.backgroundColor = UIColor.black //UIColor(red:0.03, green:0.82, blue:0.7, alpha:1)
        config.spinnerColor = UIColor.white//UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.titleTextColor = UIColor.white//UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        LoadingView.setConfig(config)
    }
    
    
}

