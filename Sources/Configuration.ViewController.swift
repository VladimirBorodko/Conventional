//
//  Configuration.ViewController.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Configuration.ViewController {

  internal init
    ( _ source: UIViewController
    )
  {
    self.source = source
    self.segues = [:]

    self.provider = .init()
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

  public func prepare
    ( for segue: UIStoryboardSegue
    , sender: Any?
    , file: StaticString = #file
    , line: UInt = #line
    )
  {
    guard let sender = sender else { return }
    if let manualSender = sender as? Transition.Sender {
      return Flare(segue)
        .flatMap(manualSender.send)
        .restore(())
        .unwrap(file, line)
    }
    if let configure = segues[segue.segueKey] {
      return Flare(configure)
        .flatMap { $0(segue, sender) }
        .restore(())
        .unwrap(file, line)
    }
  }

  public func provide
    ( for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UIViewController
  { return provider.convert(context, file: file, line: line) }

  public func transit
    ( _ context: Any
    , file: StaticString = #file
    , line: UInt = #line
    )
  { perform(converter.convert(context, file: file, line: line), file: file, line: line) }
}
