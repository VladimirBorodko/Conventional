//
//  Throwable.swift
//  Conventional
//
//  Created by Vladimir Borodko on 25/04/2018.
//

import Foundation

internal protocol FlareConvertible {
  var any: Any? { get }
  var errors: [Error] { get }
}

extension Flare: FlareConvertible {
  internal var any: Any? { return value }
}

internal struct Flare<Value>: Error {

  internal private(set) var value: Value?
  internal private(set) var errors: [Error]

  internal init
    ( _ value: Value
    )
  {
    self.value = value
    self.errors = []
  }

  private init<T>
    ( _ value: Value?
    , _ parent: Flare<T>
    , _ errors: [Error] = []
    )
  {
    let errors = errors.flatMap { error -> [Error] in
      guard let flare = error as? FlareConvertible else { return [error] }
      return flare.errors
    }
    self.value = value
    self.errors = parent.errors + errors
  }

  internal func map<T>
    ( _ transform: (Value) throws -> T
    ) -> Flare<T>
  {
    do {
      return try .init(value.map(transform), self)
    } catch let e {
      return .init(nil, self, [e])
    }
  }

  internal func flatMap<T>
    ( _ transform: (Value) -> Flare<T>
    ) -> Flare<T>
  {
    let flare = value.map(transform)
    return .init(flare?.value, self, flare?.errors ?? [])
  }

  internal func perform
    ( _ execute: (inout Value) throws -> Void
    ) -> Flare
  {
    guard var value = self.value else { return self }
    do {
      try execute(&value)
      return .init(value, self)
    } catch let e {
      return .init(value, self, [e])
    }
  }

  internal func restore
    ( _ provide: @autoclosure () -> Value
    ) -> Flare
  { return .init(value ?? provide(), self) }

  internal func debug
    ( _ tag: String = ""
    ) -> Flare
  {
    print("\(tag.isEmpty ? "" : "\(tag): ")\(errors.count)")
    return self
  }


  internal func unwrap
    ( _ file: StaticString
    , _ line: UInt
    ) -> Value
  {
    assert(errors.isEmpty, .init(reflecting: self), file: file, line: line)
    guard let value = self.value else {
      preconditionFailure(.init(reflecting: self), file: file, line: line)
    }
    return value
  }

  internal func escalate
    () throws
  { if !errors.isEmpty { throw self } }
}

extension Flare: CustomDebugStringConvertible {
  internal var debugDescription: String {
    return "There was \(errors.count) errors\n" + errors
      .map { ($0 as NSError).userInfo["Conventional.description"] as? String ?? String(reflecting: $0) }
      .joined(separator: "\n")
  }
}
