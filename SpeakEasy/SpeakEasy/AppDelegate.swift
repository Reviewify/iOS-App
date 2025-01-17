//
//  AppDelegate.swift
//  SpeakEasy: Restaurant
//
//  Created by Bryce Langlotz on 4/23/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let appId: String! = "aS5JfOEzT7lLooye3NQCzkFQagbUXaQVhKX24wnE"
    let clientKey: String! = "5cUQj1EYf3azLeyvCOtMlyxkpqHYexewg8qBqZMh"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId(appId, clientKey: clientKey)
        
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        window?.tintColor = UIColor.algorithmsGreen()
        
        PFUser.logOut()
        
        return true
    }
    
    class func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    class func showErrorWithMessage(message:String!, duration:CGFloat!) {
        var notification = CWStatusBarNotification()
        notification.notificationLabelBackgroundColor = UIColor.speakeasyRed()
        notification.notificationLabelTextColor = UIColor.whiteColor()
        notification.notificationStyle = CWNotificationStyle.NavigationBarNotification
        notification.displayNotificationWithMessage(message, forDuration: duration)
    }
    
    class func showInformationWithMessage(message:String!, duration:CGFloat!) {
        var notification = CWStatusBarNotification()
        notification.notificationLabelBackgroundColor = UIColor.algorithmsGreen()
        notification.notificationLabelTextColor = UIColor.whiteColor()
        notification.notificationStyle = CWNotificationStyle.NavigationBarNotification
        notification.displayNotificationWithMessage(message, forDuration: duration)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

