//
//  Throwable.swift
//  Conventional
//
//  Created by Vladimir Borodko on 25/04/2018.
//

import Foundation

public protocol FlareConvertible {
  var any: Any? { get }
  var errors: [Error] { get }
}

extension Flare: FlareConvertible {
  public var any: Any? { return value }
}

public struct Flare<Value>: Error {

  public private(set) var value: Value?
  public private(set) var errors: [Error]
  public private(set) var file: StaticString
  public private(set) var line: UInt

  public init
    ( _ value: Value
    , file: StaticString = #file
    , line: UInt = #line
    )
  {
    self.value = value
    self.errors = []
    self.file = file
    self.line = line
  }

  private init
    ( _ value: Value?
    , _ errors: [Error]
    , _ file: StaticString
    , _ line: UInt
    )
  {
    self.value = value
    self.errors = errors
    self.file = file
    self.line = line
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
    self.init(value, parent.errors + errors, parent.file, parent.line)

  }

  private init<T>
    ( _ parent: Flare<T>
    , _ e: Error
    )
  {
    guard let flare = e as? FlareConvertible else {
      self.init(nil, parent, [e])
      return
    }
    self.init(flare.any as? Value, parent, flare.errors)
  }

  public func map<T>
    ( _ transform: (Value) throws -> T
    ) -> Flare<T>
  {
    do {
      return try .init(value.map(transform), self)
    } catch let e {
      return .init(self, e)
    }
  }

  public func flatMap<T>
    ( _ transform: (Value) throws -> Flare<T>
    ) -> Flare<T>
  {
    do {
      let flare = try value.map(transform)
      return .init(flare?.value, self, flare?.errors ?? [])
    } catch let e {
      return .init(self, e)
    }
  }

  public func perform
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

  public func restore
    ( _ provide: @autoclosure () -> Value
    ) -> Flare
  { return .init(self.value ?? provide(), self) }

  public func unwrap
    () -> Value
  {
    assert(errors.isEmpty, String(reflecting: self), file: file, line: line)
    guard let value = self.value else {
      preconditionFailure(String(reflecting: self), file: file, line: line)
    }
    return value
  }

  public func escalate
    () throws
  {
    guard errors.isEmpty else { throw self }
  }
}

extension Flare: CustomDebugStringConvertible {
  public var debugDescription: String {
    return errors
      .map(String.init(reflecting:))
      .joined(separator: "\n")
  }
}
