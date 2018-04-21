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
//    let brief = TransitionBrief()
//    composer.transitions.append(brief)
//    let provide: TransitionBrief.Provide = {
//      let controller = try objc_throws {
//        UIStoryboard(name: storyboardName, bundle: bundle).instantiateInitialViewController()
//      }
//      guard let unwrapped = controller else {throw Temp.error}
//      return try extract(unwrapped)
//    }
    return .init()
  }

  public func instantiate
    ( from storyboardName: String = Target.conventional.collectiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    , by id: String = Target.conventional.collectiveStoryboardIdentifier
    ) -> Transition.Builder<Built>.Source<Target, Container>.Transit {
//    let brief = TransitionBrief()
//    composer.transitions.append(brief)
//    let provide: TransitionBrief.Provide = {
//      let controller = try objc_throws {
//        UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: id)
//      }
//      return try extract(controller)
//    }
    return .init()
  }

  public func make
    ( factory: @escaping () throws -> Container
    ) -> Transition.Builder<Built>.Source<Target, Container>.Transit {
//    let brief = TransitionBrief()
//    composer.transitions.append(brief)
    return .init()
  }
}
