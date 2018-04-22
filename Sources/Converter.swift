//
//  Converter.swift
//  Conventional
//
//  Created by Vladimir Borodko on 08/12/2017.
//

import Foundation

public struct Converter<Output> {

  private let converts: [String: Convert]

  internal init
    ( _ converts: [String: Convert]
    ) {
    self.converts = converts
  }

  public func canConvert<Input>
    ( _ input: Input
    ) -> Bool {
    return converts[String(reflecting: type(of: input as Any))] != nil
  }

  public func convert<Input>
    ( _ input: Input
    ) throws -> Output {
    let input = try (input as? OpaqueWrapper).map{try $0.unwrapValue()} ?? input
    guard let map = try converts[key(input)] else {throw NotRegistered(value: input)}
    return try map(input)
  }

  internal typealias Convert = (Any) throws -> Output

  public struct NotRegistered: Error {

    let value: Any
  }

  public struct NotUnique: Error {

    let type: Any.Type
  }

  public struct TypeMismatch: Error {
    
    let type: Any.Type
  }

  public class Builder {

    private var converts: [String: Convert] = [:]

    public init() {}

    public func build() -> Converter<Output> { return .init(converts) }

    public func append<Input>
      ( _: Input.Type
      , convert: @escaping (Input) throws -> Output
      ) throws -> Builder {
      let key = String(reflecting: Input.self)
      guard converts[key] == nil else {throw NotUnique(type: Input.self)}
      converts[key] = {
        guard let input = $0 as? Input else {throw TypeMismatch(type: Input.self)}
        return try convert(input)
      }
      return self
    }
  }
}
