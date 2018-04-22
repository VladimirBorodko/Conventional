//
//  Compound.Window.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Compound.Window {

  internal init<W: UIWindow>
    ( _ builder: Transition.Builder<W>
    ) throws {
    source = builder.built
    let transits = try builder.transiters.uniqueTransitions().mapValues { configure in
      return { context in
        Transition { controller in
          try configure(controller, context)
        }
      }
    }
    transiter = .init(transits)
  }

  public func perform
    ( _ transition: Transition
    ) throws {
    do {
      guard let source = source else { throw Temp.error }
      try transition.perform(source)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}
