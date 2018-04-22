//
//  Optional.swift
//  ConventionalDemo
//
//  Created by Vladimir Borodko on 22/04/2018.
//  Copyright © 2018 BorodCom. All rights reserved.
//

import Foundation

extension Optional {

  private struct UnwrapFailed: Error {}
  
  func unwrap() throws -> Wrapped {
    guard let wrapped = self else { throw UnwrapFailed() }
    return wrapped
  }

  func either(_ restore: @autoclosure ()->Wrapped) -> Wrapped {
    return self ?? restore()
  }

  func cast<T>(_: T.Type) -> Optional<T> {
    return self as? T
  }
}
