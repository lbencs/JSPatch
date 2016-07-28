//
//  AppDelegate.swift
//  Dome
//
//  Created by lben on 5/17/16.
//  Copyright © 2016 lben. All rights reserved.
//

import UIKit

/*
 Swift 中的问题：为什么AppDelegate方法中，自定义的方法没有办法覆盖，但是协议中的方法可以覆盖。
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        JPEngine.startEngine()
        let sourcePath = NSBundle.mainBundle().pathForResource("main", ofType: "js")
        #if false
            var script: String?;
            
            do {
                script = try String(contentsOfFile: sourcePath!)
                JPEngine.evaluateScript(script)
            }catch{
                script = nil
            }
        #else
            JPEngine.evaluateScriptWithPath(sourcePath)
        #endif

		
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
       
        self.configRootViewController()
		
        self.window?.rootViewController = UINavigationController(rootViewController: CATListViewController())
	
        return true
    }
	
    func configRootViewController() -> Void {
        print("log-----------configRootViewController")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("log-----------applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("log-----------applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        print("log-----------applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("log-----------applicationDidBecomeActive")
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

