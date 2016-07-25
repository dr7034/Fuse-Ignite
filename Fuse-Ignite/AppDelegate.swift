

//
//  AppDelegate.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 12/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseFacebookUtilsV4
import Fabric
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, PNObjectEventListener {
    
    var window: UIWindow?
    var drawerContainer: MMDrawerController?
    let beaconNotificationsManager = BeaconNotificationsManager()
    
    var client : PubNub
    var config : PNConfiguration
    
    override init() {
        config = PNConfiguration(publishKey: "pub-c-fc159592-ec82-4455-9f68-c5c54c9ce194", subscribeKey: "sub-c-7e58050c-5297-11e6-9236-02ee2ddab7fe")
        client = PubNub.clientWithConfiguration(config)
        client.subscribeToChannels(["Channel-k6wanlbcq"], withPresence: false)
        client.publish("Swift+PubNub!", toChannel: "Channel-k6wanlbcq", compressed: false, withCompletion: nil)
        
        super.init()
        client.addListener(self)
    }
    
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        print(message)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        Parse.enableLocalDatastore()
        
        //Init Parse
        Parse.setApplicationId("d5LFK2as7ay0obVjQ2pMMRQkkMaBbPixMSJwo2dc", clientKey: "sTfq0xw8w0SoxNwZP0gn1ZWHL3f6anQORVV95BfU")
        
        //Init PFFacebookUtils
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    
        //[Optional] Track statistics around application opens
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
                
        //Register for Push Notifications through Parse
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
            
            buildUserInterface()
        
        //setup app with estimote
        ESTConfig.setupAppID("fuse-ignite", andAppToken: "9f394667684dbab1f9264c8d33616b84")

//        //Beacon Notification when in range (Ignite0)
//        self.beaconNotificationsManager.enableNotificationsForBeaconID(
//            BeaconID(UUIDString: "712CCB65-D5C3-047E-9CF3-E3A683026081", major: 1, minor: 1),
//            enterMessage: "You have entered an event region. Swipe this notification to check in.",
//            exitMessage: " "
//        )
        
        //Enable estimote analytics
        ESTConfig.enableRangingAnalytics(true)
        ESTConfig.enableMonitoringAnalytics(true)
        
        
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: .Alert, categories: nil))

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock { (success:Bool, error: NSError?) -> Void in
//            print("Registration successful? \(success)")
        }
        
    }
    
    func application(application: UIApplication, didRecieveRemoteNotification userInfo:[NSObject : AnyObject], fetchCompletionHandler:(UIBackgroundFetchResult) -> Void) {
        
        PFPush.handlePush(userInfo)
        fetchCompletionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        print("Failed to register \(error.localizedDescription)")
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        
        PFPush.handlePush(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData)
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
        FBSDKAppEvents.activateApp()
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func buildUserInterface()
    {
        
        
        let userName:String? =  NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        
        if(userName != nil)
        {
            // Navigate to Protected page
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            // Create View Controllers
            let eventFeedPage:EventFeedTableViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("EventFeedTableViewController") as! EventFeedTableViewController
            
            let leftSideMenu:LeftSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
            
            let rightSideMenu:RightSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController
            
            
            
            // Wrap into Navigation controllers
            let eventFeedPageNav = UINavigationController(rootViewController:eventFeedPage)
            let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
            let rightSideMenuNav = UINavigationController(rootViewController:rightSideMenu)
            
            
            drawerContainer = MMDrawerController(centerViewController: eventFeedPageNav, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: rightSideMenuNav)
            
            drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
            drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
            
            
            window?.rootViewController = drawerContainer
        }

    }
}

