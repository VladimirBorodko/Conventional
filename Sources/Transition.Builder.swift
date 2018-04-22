//
//  Transition.Builder.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder {
  
  internal init
    ( _ built: Built
    ) {
    self.built = built
  }

  public func register<Target: UIViewController>
    ( _: Target.Type
    ) -> Source<Target, Target> {
    return .init(builder: self, extract: {$0})
  }

  public func register<Target: UIViewController, Container: UIViewController>
    ( _: Target.Type
    , containedIn _: Container.Type
    , extract: @escaping Source<Target, Container>.Extract = Target.conventional.extract()
    ) -> Source<Target, Container> {
    return .init(builder: self, extract: extract)
  }
}

extension Transition.Builder where Built: ConventionComplying {

  public func mock<Context>
    ( for _: Context.Type
    , perform: @escaping (Built, Context) throws -> Void = Built.conventional.mock()
    ) -> Transition.Builder<Built> {
    var builder = self
    let brief = Transition.Brief.Transiter(contextType: Context.self) { built, context in
      guard let built = built as? Built else { throw Temp.error }
      guard let context = context as? Context else { throw Temp.error }
      try perform(built, context)
    }
    builder.transiters.append(brief)
    return builder
  }
}

extension Transition.Builder where Built: UIViewController {

  public func build() throws -> Compound.ViewController {
    do {
      return try .init(self)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}

extension Transition.Builder where Built: UIWindow {
  
  public func build() throws -> Compound.Window {
    do {
      return try .init(self)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}
