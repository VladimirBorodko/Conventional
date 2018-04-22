//
//  OpaqueWrapper.swift
//  Conventional
//
//  Created by Vladimir Borodko on 04/04/2018.
//

import Foundation

public protocol OpaqueWrapper {

  func unwrapValue() throws -> Any
}

extension Optional: OpaqueWrapper {
  
  public func unwrapValue() throws -> Any {
    guard let wrapped = self else { throw OpaqueWrapperUnwrapFailed(type: Wrapped.self) }
    return wrapped
  }
}

internal func key
  ( _ value: Any
  ) throws -> String {
  let valueType = try (value as? OpaqueWrapper)
    .map{try type(of: $0.unwrapValue())}
    ?? value as? AnyClass
    ?? type(of: value)
  return String(reflecting: valueType)
}
