//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Keith Lazuka on 9/19/15.
//  Copyright © 2015 Microsoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    runGraphDemo()
//    runApplesAndOrangesDemo()
    
    return true
  }

}

