//
//  Configuration.Window.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Configuration.Window {

  internal init<W: UIWindow>
    ( _ builder: Transition.Builder<W>
    ) throws
  {
    source = builder.built
    let transits = try builder.transiters.uniqueTransitions().mapValues { configure in
      return { context in
        Transition { controller in
          try configure(controller, context)
        }
      }
    }
    converter = .init(transits)
  }

  public func perform
    ( _ transition: Transition
    ) throws
  {
    do {
      let source = try unwrap(self.source)
      try transition.perform(source)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func transit
    ( _ context: Any
    ) throws
  {
    do {
      let source = try unwrap(self.source)
      try converter.convert(context).perform(source)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}
