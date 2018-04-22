//
//  Compound.ViewController.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Compound.ViewController {

  internal init<VC: UIViewController>
    ( _ builder: Transition.Builder<VC>
    ) throws {
    source = builder.built
    segues = try builder.seguers.uniqueSegues()
    let transits = try builder.transiters.uniqueTransitions().mapValues { configure in
      return { context in
        Transition { controller in
          try configure(controller, context)
        }
      }
    }
    transiter = .init(transits)
    provider = try .init(builder.providers.uniqueProviders())
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

  public func prepare
    ( for segue: UIStoryboardSegue
    , sender: Any?
    ) throws {
    do {
      guard let sender = sender else { throw Temp.error }
      if let manualSender = sender as? Transition.Brief.Seguer.Sender {
        return try manualSender.send(segue)
      }
      guard let seguer = segues[.init(segue)] else { return }
      try seguer(segue, sender)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func provide(for context: Any) throws -> UIViewController {
    do {
      return try provider.convert(context)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func transit
    ( _ context: Any
    ) throws {
    do {
      guard let source = source else { throw Temp.error }
      try transiter.convert(context).perform(source)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}
