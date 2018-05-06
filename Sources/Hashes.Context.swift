//
//  Hashes.Context.swift
//  Conventional
//
//  Created by Vladimir Borodko on 06/05/2018.
//

import Foundation

extension Hashes.Context {

  internal init
    ( type: Any.Type
    )
  {
    self.context = type
    self.contextId = .init(type)
  }

  internal init
    ( context: Any
    ) throws
  {
    let context = try unwrapType(context)
    self.context = context
    self.contextId = .init(context)
  }
}

extension Hashes.Context: Hashable {

  internal var hashValue: Int { return contextId.hashValue }

  internal static func ==
    ( lhs: Hashes.Context
    , rhs: Hashes.Context
    ) -> Bool
  { return lhs.contextId == rhs.contextId }
}

extension Hashes.Context: CustomDebugStringConvertible {
  
  internal var debugDescription: String {
    return "context type \"\(String(reflecting: context))\""
  }
}
