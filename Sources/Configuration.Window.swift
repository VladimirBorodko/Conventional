//
//  Configuration.Window.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Configuration.Window {

  internal init
    ( _ source: UIWindow
    )
  {
    self.source = source
    self.converter = .init(restore: Transition.empty)
  }

  public func perform
    ( _ transition: Transition
    , file: StaticString = #file
    , line: UInt = #line
    )
  {
    return Flare(source)
      .map(strongify)
      .flatMap(transition.perform)
      .restore(())
      .unwrap(file, line)
  }

  public func transit
    ( _ context: Any
    , file: StaticString = #file
    , line: UInt = #line
    )
  { perform(converter.convert(context, file: file, line: line), file: file, line: line) }
}
