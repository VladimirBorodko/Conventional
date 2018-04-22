//
//  NSObject+DisposeBag.swift
//  ConventionalDemo
//
//  Created by Vladimir Borodko on 22/04/2018.
//  Copyright © 2018 BorodCom. All rights reserved.
//

import Foundation
import RxSwift

extension NSObject {

  var associatedBag: DisposeBag {
    objc_sync_enter(self)
    defer {objc_sync_exit(self)}
    struct Static { static var context: UInt8 = 0 }
    var newBag: DisposeBag {
      let bag = DisposeBag()
      objc_setAssociatedObject(self, &Static.context, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return bag
    }
    return objc_getAssociatedObject(self, &Static.context)
      .cast(DisposeBag.self)
      .either(newBag)
  }
}
