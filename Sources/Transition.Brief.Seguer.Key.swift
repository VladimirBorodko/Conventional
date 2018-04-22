//
//  Transition.Brief.Seguer.Key.swift
//  Conventional
//
//  Created by Vladimir Borodko on 22/04/2018.
//

import UIKit

extension Transition.Brief.Seguer.Key: Hashable {

  internal var hashValue: Int {
    return id.hashValue ^ destination.hash()
  }

  internal static func ==
    (lhs: Transition.Brief.Seguer.Key
    , rhs: Transition.Brief.Seguer.Key
    ) -> Bool
  { return lhs.id == rhs.id && lhs.destination === rhs.destination }

  internal init
    ( _ brief: Transition.Brief.Seguer )
  {
    self.id = brief.segueId
    self.destination = brief.destinationType
  }

  internal init
    ( _ segue: UIStoryboardSegue )
  {
    self.id = segue.identifier ?? ""
    self.destination = type(of: segue.destination)
  }
}
