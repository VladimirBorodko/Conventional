//
//  WindowCompound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import UIKit

public class WindowStock {

  public let converter: AnyConverter<Transition> = {
    return AnyConverter<Transition>.Builder.init().build()
  }()
  internal weak var source: UIWindow?

  internal init() { }

  public func perform
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
