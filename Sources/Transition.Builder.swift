//
//  Transition.Builder.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder {
  public func mock<Model>
    ( for _: Model.Type
    ) -> Transition.Builder<Built> {
    var builder = self
    builder.mocks.append(.init(contextType: Model.self))
    return builder
  }

  public func register<Target: UIViewController>
    ( _: Target.Type
    ) -> Transition.Builder<Built>.Destination<Target, Target> {
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
    ) -> Transition.Builder<Built>.Destination<Target, Container> {
    return .init(builder: self, extract: {
      guard let containder = $0 as? Container else {
        throw Temp.error
      }
      return try extract(containder)
    })
  }
}
