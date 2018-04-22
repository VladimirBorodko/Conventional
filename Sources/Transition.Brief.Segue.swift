//
//  Transition.Brief.Segue.swift
//  Conventional
//
//  Created by Vladimir Borodko on 22/04/2018.
//

import Foundation

extension Array where Element == Transition.Brief.Segue {

  internal func uniqueSegues() throws -> [Transition.Brief.Segue.Key: Transition.Configure] {
    return try self.reduce(into: [:]) { dict, brief in
      let key = Transition.Brief.Segue.Key(brief)
      guard dict[key] == nil else { throw Temp.error }
      dict[key] = brief.configure
    }
  }
}
