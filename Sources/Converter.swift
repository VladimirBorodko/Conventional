//
//  Converter.swift
//  Conventional
//
//  Created by Vladimir Borodko on 08/12/2017.
//

import Foundation

public struct Converter<Output> {

  internal var converts: [Hashes.Context: Convert]
  internal var restore: Restore?

  internal init
    ( converts: [Hashes.Context: Convert] = [:]
    , restore: Restore? = nil
    )
  {
    self.converts = converts
    self.restore = restore
  }

  public func mayConvert<Input>
    ( _ input: Input
    ) -> Bool
  { return nil != (try? converts.value(for: .init(context: input))) }

  public func convert<Input>
    ( _ input: Input
    , file: StaticString = #file
    , line: UInt = #line
    ) -> Output
  {
    let flare = Flare(input)
      .map(Hashes.Context.init(context:))
      .map(converts.value)
      .flatMap { $0(input) }
    return restore
      .map { restore in flare
        .restore(restore())
        .unwrap(file, line)
      }
      ?? flare.unwrap(file, line)
  }

  internal typealias Restore = () -> Output
  internal typealias Convert = (Any) -> Flare<Output>
}
