//
//  Errors.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import Foundation

internal enum Errors {

  internal struct ObjectDellocated: Error {
    
    let type: AnyClass
  }

  internal struct NotUnique<Key: Hashable>: Error {

    let key: Key
  }

  internal struct NotRegistered<Key: Hashable>: Error {

    let key: Key
  }

  internal struct UnwrapFailed: Error {

    let type: Any.Type
  }

  internal struct WrongInstance: Error {

    let type: AnyClass
  }

  internal struct CastFailed: Error {

    let actual: Any.Type
    let expected: Any.Type
  }
}
