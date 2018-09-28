//
//  AppDelegate.swift
//  ConventionalDemo
//
//  Created by Vladimir Borodko on 29/03/2018.
//  Copyright © 2018 BorodCom. All rights reserved.
//

import UIKit
import Conventional

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var router: Router?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    router = Router(window: window!, launchOptions: launchOptions)
    return false
  }
}

