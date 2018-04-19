//
//  SegueBrief.swift
//  Conventional
//
//  Created by Vladimir Borodko on 10/04/2018.
//

import UIKit

internal class SegueBrief {
  internal var segueId: String!
  internal var destinayionType: AnyClass!
  internal var configure: Configure!
  internal var extract: Extract!

  internal typealias Extract = (UIStoryboardSegue) throws -> UIViewController
  internal typealias Configure = (_ target: UIViewController, _ sender: Any) throws -> Void
  internal typealias Perform = (_ segue: UIStoryboardSegue,  _ sender: Any) throws -> Void

  internal struct Key: Hashable {
    internal let id: String
    internal let destination: String

    internal var hashValue: Int {return id.hashValue ^ destination.hashValue}

    internal static func ==
      (lhs: Key
      , rhs: Key
      ) -> Bool {
      return lhs.id == rhs.id && lhs.destination == rhs.destination
    }

    internal init
      ( _ brief: SegueBrief
      ) {
      self.id = brief.segueId
      self.destination = String(reflecting: brief.destinayionType!)
    }

    internal init
      ( _ segue: UIStoryboardSegue
      ) {
      self.id = segue.identifier ?? ""
      self.destination = String(reflecting: type(of: segue.destination))
    }
  }
}
