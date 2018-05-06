//
//  Hashes.Segue.swift
//  Conventional
//
//  Created by Vladimir Borodko on 06/05/2018.
//

import Foundation

extension Hashes.Segue: Hashable {

  internal var hashValue: Int { return id.hashValue ^ destination.hash() }

  internal static func ==
    (lhs: Hashes.Segue
    , rhs: Hashes.Segue
    ) -> Bool
  { return lhs.id == rhs.id && lhs.destination === rhs.destination }
}

extension Hashes.Segue: CustomDebugStringConvertible {
  
  internal var debugDescription: String {
    return "segue destination type \"\(String(reflecting: destination))\", identifier: \"\(id)\""
  }
}

extension UIStoryboardSegue {

  internal var segueKey: Hashes.Segue {
    return .init(id: self.identifier ?? "", destination: type(of: self.destination))
  }
}
