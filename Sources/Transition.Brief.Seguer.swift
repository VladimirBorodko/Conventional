//
//  Transition.Brief.Seguer.swift
//  Conventional
//
//  Created by Vladimir Borodko on 22/04/2018.
//

import Foundation

extension Array where Element == Transition.Brief.Seguer {

  internal func uniqueSegues() throws -> [Transition.Brief.Seguer.Key: Transition.Configure] {
    return try self.reduce(into: [:]) { dict, brief in
      let key = Transition.Brief.Seguer.Key(brief)
      guard dict[key] == nil else { throw Errors.NotUnique(key: key) }
      dict[key] = brief.configure
    }
  }
}
