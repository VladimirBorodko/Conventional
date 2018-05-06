//
//  Errors.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import Foundation

internal enum Errors {

  internal struct ObjectDeallocated: Error, CustomDebugStringConvertible {
    
    internal let type: AnyClass
    internal var debugDescription: String { return "Error: \"\(String(reflecting: type))\" was deallocated" }
  }

  internal struct NotUniqueReuseId: Error, CustomDebugStringConvertible {

    internal let id: String
    internal let kind: String?
    internal var debugDescription: String {
      return kind.map {"Error: reuseIdentifier \"\(id)\" not unique for kind \"\($0)\""}
      ?? "Error: reuseIdentifier \"\(id)\" not unique"

    }
  }

  internal struct NotUnique<Key: Hashable & CustomDebugStringConvertible>: Error, CustomDebugStringConvertible {

    internal let key: Key
    internal var debugDescription: String { return "Error: \(String(reflecting: key)) not unique" }
  }

  internal struct NotRegistered<Key: Hashable & CustomDebugStringConvertible>: Error, CustomDebugStringConvertible {

    internal let key: Key
    internal var debugDescription: String { return "Error: \(String(reflecting: key)) not registered" }
  }

  internal struct UnwrapFailed: Error, CustomDebugStringConvertible {

    internal let type: Any.Type
    internal var debugDescription: String { return "Error: failed to unwrap \"\(String(reflecting: type))\"" }
  }

  internal struct WrongInstance: Error, CustomDebugStringConvertible {

    internal let type: AnyClass
    internal var debugDescription: String { return "Error: wraong instance of \"\(String(reflecting: type))\"" }
  }

  internal struct CastFailed: Error, CustomDebugStringConvertible {

    internal let actual: Any.Type
    internal let expected: Any.Type
    internal var debugDescription: String { return "Error: failed to cast from \"\(String(reflecting: actual))\" to \"\(String(reflecting: expected))\"" }
  }
}
