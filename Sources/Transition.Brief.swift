//
//  Transition.Brief.swift
//  Conventional
//
//  Created by Vladimir Borodko on 22/04/2018.
//

import Foundation

extension Array where Element == Transition.Brief {

  internal func uniqueSegues
    () -> Flare<[Hashes.Segue: Transition.Configure]>
  {
    return self.reduce(Flare([:])) { flare, brief in
      guard case let .segue(id, destination, configure) = brief else { return flare }
      let key = Hashes.Segue(id: id, destination: destination)
      return flare.perform { dict in
        guard dict[key] == nil else { throw Errors.NotUnique(key: key) }
        dict[key] = configure
      }
    }
  }

  internal func uniqueProviders
    () -> Flare<[Hashes.Context: Transition.Provide]>
  {
    return self.reduce(Flare([:])) { flare, brief in
      guard case let .provide(contextType, provide) = brief else { return flare }
      let key = Hashes.Context(type: contextType)
      return flare.perform { dict in
        guard dict[key] == nil else { throw Errors.NotUnique(key: key) }
        dict[key] = provide
      }
    }
  }

  internal func uniqueTransitions
    () -> Flare<[Hashes.Context: Transition.Transit]>
  {
    return self.reduce(Flare([:])) { flare, brief in
      guard case let .transit(contextType, configure) = brief else { return flare }
      let key = Hashes.Context(type: contextType)
      return flare.perform { dict in
        guard dict[key] == nil else { throw Errors.NotUnique(key: key) }
        dict[key] = configure
      }
    }
  }
}
