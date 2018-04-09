//
//  WindowCompound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import Foundation

public class WindowCompound {

  init() { }

  func perform
    ( _ transition: Transition
    ) {
  }

  var converter: AnyConverter<Transition> {
    return AnyConverter<Transition>.Builder.init().build()
  }
}
