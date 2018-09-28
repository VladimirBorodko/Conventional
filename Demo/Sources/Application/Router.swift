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

  let windowConfiguration: Configuration.Window

  init(window: UIWindow, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

    windowConfiguration = window.conventional.configuration
      .register(WelcomeC.self).instantiateInitial().changeRoot().noContext()
      .build()

    windowConfiguration.transit(WelcomeC.self)
  }
}
