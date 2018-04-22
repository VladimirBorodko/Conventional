//
//  Transition.Brief.Controller.swift
//  Conventional
//
//  Created by Vladimir Borodko on 22/04/2018.
//

import Foundation

extension Array where Element == Transition.Brief.Controller {
  internal func uniqueTransitions() throws -> [String: Transition.Configure] {
    return try self.reduce(into: [:]) { dict, brief in
      let key = String(reflecting: brief.contextType)
      guard dict[key] == nil else { throw Temp.error }
      dict[key] = brief.configure
    }
  }
}
