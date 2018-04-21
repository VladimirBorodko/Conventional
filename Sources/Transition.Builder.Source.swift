//
//  Transition.Builder.Source.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source {
  
  public func instantiateInitial
    ( from storyboardName: String = Target.conventional.exclusiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    ) -> Transition.Builder<Built>.Source<Target, Container>.Transit {
    return .init(source: self) {
      let controller = try objc_throws {
        UIStoryboard(name: storyboardName, bundle: bundle).instantiateInitialViewController()
      }
      guard let container = controller as? Container else {
        throw Temp.error
      }
      return container
    }
  }

  public func instantiate
    ( from storyboardName: String = Target.conventional.collectiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    , by id: String = Target.conventional.collectiveStoryboardIdentifier
    ) -> Transition.Builder<Built>.Source<Target, Container>.Transit {
    return .init(source: self) {
      let controller = try objc_throws {
        UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: id)
      }
      guard let container = controller as? Container else {
        throw Temp.error
      }
      return container
    }
  }

  public func make
    ( factory: @escaping Transit.Factory
    ) -> Transition.Builder<Built>.Source<Target, Container>.Transit {
    return .init(source: self, factory: factory)
  }
}
