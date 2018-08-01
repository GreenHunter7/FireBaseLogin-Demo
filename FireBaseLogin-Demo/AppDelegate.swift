//
//  AppDelegate.swift
//  FireBaseLogin-Demo
//
//  Created by Mohamed Hussien on 01/08/2018.
//  Copyright © 2018 Mohamed Hussien. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        
        FirebaseApp.configure()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"csrBhFNaNgDYQ5mjPoE3BODbH", consumerSecret:"boWYJ8dCvonYrzda2TrTlNxF6SfurWt6wTlCFQH4M9L8yvmbSJ")
        GIDSignIn.sharedInstance().clientID = "809562943031-5aaf7snp3tf7q1f4ikrps87pnodb5h2e.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        
        return true
    }

    //this code for google, facebook and twitter signin
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//        
//        let handledGoogle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//        
//        let handledTwitter = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
//        
//        if handledGoogle || handled || handledTwitter {
//            return true
//        }else{
//            return false
//        }
//    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        let handledGoogle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        let handledTwitter = TWTRTwitter.sharedInstance().application(app, open: url, options: options)

        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?


        let firebase = FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication)
    
        if handledGoogle || handled || handledTwitter || firebase! {
            return true
        }else{
            return false
        }
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

