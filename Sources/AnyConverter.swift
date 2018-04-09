//
//  AnyConverter.swift
//  Conventional
//
//  Created by Vladimir Borodko on 08/12/2017.
//

import Foundation

public struct AnyConverter<Output> {
  private let mappers: [String: (Any)throws->Output]

  fileprivate init
    ( mappers: [String: (Any)throws->Output]
    ) {
    self.mappers = mappers
  }

  public func canConvert<Input>
    ( _ input: Input
    ) -> Bool {
    return mappers[String(reflecting: type(of: input as Any))] != nil
  }

  public func convert<Input>
    ( _ input: Input
    ) throws -> Output {
    let input = try (input as? OpaqueWrapper).map{try $0.unwrapValue()} ?? input
    let inputType = type(of: input as Any)
    guard let map = mappers[String(reflecting: inputType)] else {throw NotRegistered(type: inputType)}
    return try map(input)
  }

  public class Builder {

    public var mappers: [String: (Any)throws->Output] = [:]
    public init() {}

    public func build() -> AnyConverter<Output> { return .init(mappers: mappers) }

    public func append<Input>
      ( _: Input.Type
      , convert: @escaping (Input)throws->Output
      ) throws -> Builder {
      let key = String(reflecting: Input.self)
      guard mappers[key] == nil else {throw NotUnique(type: Input.self)}
      mappers[key] = {
        guard let input = $0 as? Input else {throw TypeMismatch(type: Input.self)}
        return try convert(input)
      }
      return self
    }
  }

  public struct NotRegistered: Error {
    let type: Any.Type
  }

  public struct NotUnique: Error {
    let type: Any.Type
  }
  
  public struct TypeMismatch: Error {
    let type: Any.Type
  }
}
