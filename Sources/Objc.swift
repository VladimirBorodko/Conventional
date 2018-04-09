//
//  Objc.swift
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
