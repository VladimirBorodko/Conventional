//
//  Helpers.swift
//  Conventional
//
//  Created by Vladimir Borodko on 26/03/2018.
//

import Foundation

public func objc_throws<T>
  ( _ block: () -> T
  ) throws -> T
{
  return try withoutActuallyEscaping(block) { escapablePredicate in
    var result: T! = nil
    try Objc.performOrThrow { result = escapablePredicate() }
    return result
  }
}

internal func makeKey
  ( _ value: Any
  ) throws -> String
{
  let valueType = (value as? OpaqueWrapper)
    .flatMap { try? $0.unwrapValue() }
    .map { $0 is AnyClass ? $0 : type(of:$0) }
    ?? value as? AnyClass
    ?? type(of: value)
  return String(reflecting: valueType)
}

internal func cast<T>
  ( _ value: Any
  , _ toType: T.Type
  ) throws -> T
{
  guard let casted = value as? T else {
    throw Errors.CastFailed(actual: type(of: value), expected: T.self)
  }
  return casted
}

internal func cast<F, T>
  ( _ value: F?
  , _ toType: T.Type
  ) throws -> T
{
  guard let unwrapped = value else { throw Errors.UnwrapFailed(type: F.self) }
  guard let casted = unwrapped as? T else { throw Errors.CastFailed(actual: type(of: value), expected: T.self) }
  return casted
}

internal func unwrap<T: AnyObject>
  ( _ value: T?
  ) throws -> T
{
  guard let value = value else { throw Errors.ObjectDellocated(type: T.self)}
  return value
}

internal func checkSameInstance<T: AnyObject>
  ( _ stored: T?
  , _ provided: T
  ) throws
{
  guard let stored = stored else { throw Errors.ObjectDellocated(type: T.self) }
  guard stored === provided else { throw Errors.WrongInstance(type: T.self) }
}
