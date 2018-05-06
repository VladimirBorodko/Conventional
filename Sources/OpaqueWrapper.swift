//
//  OpaqueWrapper.swift
//  Conventional
//
//  Created by Vladimir Borodko on 04/04/2018.
//

import Foundation

public protocol OpaqueWrapper {

  func unwrapContext
    () throws -> Any
}

extension Optional: OpaqueWrapper {

  public func unwrapContext
    () throws -> Any
  {
    guard let wrapped = self else { throw Errors.UnwrapFailed(type: Wrapped.self) }
    return wrapped
  }
}
