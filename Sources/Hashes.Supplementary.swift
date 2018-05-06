//
//  Hashes.Supplementary.swift
//  Conventional
//
//  Created by Vladimir Borodko on 06/05/2018.
//

import Foundation

extension Hashes.Supplementary {

  internal init
    ( kind: String
    , type: Any.Type
    )
  {
    self.kind = kind
    self.context = type
    self.contextId = .init(type)
  }

  internal init
    ( kind: String
    , context: Any
    ) throws
  {
    let context = try unwrapType(context)
    self.kind = kind
    self.context = context
    self.contextId = .init(context)
  }

  internal static func header
    ( for context: Any
    ) throws -> Hashes.Supplementary
  { return try .init(kind: UICollectionElementKindSectionHeader, context: context) }

  internal static func footer
    ( for context: Any
    ) throws -> Hashes.Supplementary
  { return try .init(kind: UICollectionElementKindSectionFooter, context: context) }
}

extension Hashes.Supplementary: Hashable {

  internal var hashValue: Int { return kind.hashValue ^ contextId.hashValue }

  internal static func ==
    ( lhs: Hashes.Supplementary
    , rhs: Hashes.Supplementary
    ) -> Bool
  { return lhs.contextId == rhs.contextId && lhs.kind == rhs.kind }
}

extension Hashes.Supplementary: CustomDebugStringConvertible {
  
  internal var debugDescription: String {
    return "supplementary kind \"\(kind)\", context type \"\(String(reflecting: context))\""
  }
}

extension String {

  internal func supplementaryKey
    ( for context: Any
    ) throws -> Hashes.Supplementary
  { return try .init(kind: self, context: context) }
}
