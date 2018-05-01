//
//  Optional.swift
//  ConventionalDemo
//
//  Created by Vladimir Borodko on 22/04/2018.
//  Copyright © 2018 BorodCom. All rights reserved.
//

import Foundation

extension Optional {

  struct UnwrapFailed: Error {}

  func unwrap(_ whenNil: @autoclosure () -> Error = UnwrapFailed()) throws -> Wrapped {
    guard let wrapped = self else { throw whenNil() }
    return wrapped
  }

  func restore(_ whenNil: @autoclosure () -> Wrapped) -> Wrapped {
    return self ?? whenNil()
  }

  func restoreMap(_ whenNil: () throws -> Wrapped?) rethrows -> Optional {
    return try self ?? whenNil()
  }

  func filter(_ include: Bool) -> Optional {
    return include ? self : nil
  }

  func cast<T>(_: T.Type) -> Optional<T> {
    return self as? T
  }

  func flatten<T>() -> T? where Wrapped == T? {
    return self.flatMap {$0}
  }

  var hasSome: Bool {
    switch self {
    case .some: return true
    case .none: return false
    }
  }
}
