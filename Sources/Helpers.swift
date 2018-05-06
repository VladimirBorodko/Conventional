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

internal func unwrapType
  ( _ value: Any
  ) throws -> Any.Type
{
  return try (value as? OpaqueWrapper)
    .map { try $0.unwrapContext() }
    .map { $0 as? Any.Type ?? type(of:$0) }
    ?? (value as? Any.Type)
    ?? type(of: value)
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

internal func strongify<T: AnyObject>
  ( _ value: T?
  ) throws -> T
{
  guard let value = value else { throw Errors.ObjectDeallocated(type: T.self)}
  return value
}

internal func unwrap<T>
  ( _ value: T?
  ) throws -> T
{
  guard let value = value else { throw Errors.UnwrapFailed(type: T.self)}
  return value
}

internal func checkSameInstance<T: AnyObject>
  ( _ stored: T?
  , _ provided: T
  ) throws
{
  guard let stored = stored else { throw Errors.ObjectDeallocated(type: T.self) }
  guard stored === provided else { throw Errors.WrongInstance(type: T.self) }
}

extension Optional {
  internal func unwrap
    ( _ orThrow: @autoclosure () -> Error
    ) throws -> Wrapped
  {
    guard let wrapped = self else {throw orThrow()}
    return wrapped
  }
}

extension Dictionary where Key: CustomDebugStringConvertible {
  internal func value(for key: Key) throws -> Value {
    guard let value = self[key] else { throw Errors.NotRegistered(key: key) }
    return value
  }
}

