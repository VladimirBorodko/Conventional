//
//  Router.swift
//  ConventionalDemo
//
//  Created by Vladimir Borodko on 22/04/2018.
//  Copyright © 2018 BorodCom. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Conventional

class Router {

  let windowConfiguration: Configuration.Window?

  init(appDelegate: UIApplicationDelegate, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

    windowConfiguration = try? appDelegate.window.unwrap().unwrap().conventional.configuration
      .register(WelcomeC.self).instantiateInitial().changeRoot().noContext()
      .build()

    _ = try? windowConfiguration?.transit(WelcomeC.self)
  }
}
