//
//  Transition.Builder.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder {
  
  public func mock<Context>
    ( for _: Context.Type
    ) -> Transition.Builder<Built> {
    var builder = self
    builder.mocks.append(.init(contextType: Context.self))
    return builder
  }

  public func register<Target: UIViewController>
    ( _: Target.Type
    ) -> Transition.Builder<Built>.Source<Target, Target> {
    return .init(builder: self, extract: {
      guard let target = $0 as? Target else {
        throw Temp.error
      }
      return target
    })
  }

  public func register<Target: UIViewController, Container: UIViewController>
    ( _: Target.Type
    , containedIn _: Container.Type
    , extract: @escaping (Container) throws -> Target = Target.conventional.extract
    ) -> Transition.Builder<Built>.Source<Target, Container> {
    return .init(builder: self, extract: {
      guard let containder = $0 as? Container else {
        throw Temp.error
      }
      return try extract(containder)
    })
  }
}

extension Transition.Builder where Built: UIViewController {

  public func build() -> Compound.ViewController {
    do {
      return try .init(self)
    } catch let e {
      fatalError("\(e)")
    }
  }
}

extension Transition.Builder where Built: UIWindow {
  
  public func build() -> Compound.Window {
    do {
      return try .init(self)
    } catch let e {
      fatalError("\(e)")
    }
  }
}
