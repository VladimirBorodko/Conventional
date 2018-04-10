//
//  WindowCompound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import UIKit

public class WindowCompound {

  public let converter: AnyConverter<Transition> = {
    return AnyConverter<Transition>.Builder.init().build()
  }()
  weak var source: UIWindow?

  init() { }

  func perform
    ( _ transition: Transition
    ) {
    do {
      guard let source = source else {
        throw Temp.error
      }
      try transition.perform(source)
    } catch let e {
      preconditionFailure("\(e)")
    }
  }
}
