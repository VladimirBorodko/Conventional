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
    )
  { self.converts = converts }

  public func canConvert<Input>
    ( _ input: Input
    ) -> Bool
  {
    guard let key = try? makeKey(input) else {return false}
    return converts[key] != nil
  }

  public func convert<Input>
    ( _ input: Input
    ) throws -> Output
  {
    let key = try makeKey(input)
    guard let map = converts[key] else {throw Errors.NotRegistered(key: key)}
    return try map(input)
  }

  internal typealias Convert = (Any) throws -> Output

  public class Builder {

    private var converts: [String: Convert] = [:]

    public init() {}

    public func build() -> Converter<Output> { return .init(converts) }

    public func append<Input>
      ( _: Input.Type
      , convert: @escaping (Input) throws -> Output
      ) throws -> Builder {
      let key = String(reflecting: Input.self)
      guard converts[key] == nil else { throw Errors.NotUnique(key: key) }
      converts[key] = {
        let input = try cast($0, Input.self)
        return try convert(input)
      }
      return self
    }
  }
}
