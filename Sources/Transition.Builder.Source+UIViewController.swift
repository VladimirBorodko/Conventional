//
//  Transition.Builder.Source+UIViewController.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source where Built: UIViewController {

  public func storyboardSegue
    ( with id: String = Target.conventional.storyboardSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, UIStoryboardSegue>.Configurator {
    //    let brief = SegueBrief()
    //    brief.segueId = id
    //    brief.destinayionType = Controller.self
    //    brief.extract = { segue in
    //      guard let destination = segue.destination as? Controller else {
    //        throw ExtractFailed(type: Controller.self)
    //      }
    //      return destination
    //    }
    //    composer.segues.append(brief)
    return .init()
  }

  public func manualSegue
    ( id: String = Target.conventional.storyboardSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, Container>.Configurator {
    //    let brief = TransitionBrief()
    //    composer.transitions.append(brief)
    return .init()
  }
}
