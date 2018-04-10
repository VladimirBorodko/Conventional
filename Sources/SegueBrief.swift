//
//  SegueBrief.swift
//  Conventional
//
//  Created by Vladimir Borodko on 10/04/2018.
//

import UIKit

class SegueBrief {
  var segueId: String!
  var senderType: Any.Type!
  var configure: Configure!
  var extract: Extract!

  typealias Extract = (UIStoryboardSegue) throws -> AnyObject

  typealias Configure = (_ segue: UIStoryboardSegue,  _ sender: Any) throws -> Void

  struct Key: Hashable {
    let id: String
    let sender: String

    var hashValue: Int { return id.hashValue ^ sender.hashValue }

    static func ==
      (lhs: Key
      , rhs: Key
      ) -> Bool {
      return lhs.id == rhs.id && lhs.sender == rhs.sender
    }

    init
      ( _ brief: SegueBrief
      ) {
      self.id = brief.segueId
      self.sender = String(reflecting: brief.senderType)
    }

    init
      ( _ segue: UIStoryboardSegue
      , _ sender: Any
      ) {
      self.id = segue.identifier ?? ""
      self.sender = String(reflecting: type(of: sender))
    }
  }
}
