//
//  Transition.Builder.Source+UIViewController.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source where Built: UIViewController, Container: UIViewController {

  public func storyboardSegue
    ( with id: String = Target.conventional.storyboardSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, UIStoryboardSegue>.Configurator {
    return .init(built: builder.built) { _, configure in
      var builder = self.builder
      let extract = self.extract
      let chapter = Transition.SegueChapter(destinationType: Container.self, segueId: id) { segue, sender in
        guard let segue = segue as? UIStoryboardSegue else { throw Temp.error }
        let target = try extract(segue.destination)
        try configure(target, sender)
      }
      builder.segues.append(chapter)
      return builder
    }
  }

  public func manualSegue
    ( id: String = Target.conventional.storyboardSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, Container>.Configurator {
    return .init(built: builder.built) { contextType, configure in
      var builder = self.builder
      let extract = self.extract
      let chapter = Transition.ControllerChapter(contextType: contextType) { controller, context in
        guard let controller = controller as? Built else { throw Temp.error }
        let sender = Transition.Sender { segue in
          let target = try extract(segue.destination)
          try configure(target, context)
        }
        try objc_throws {
          controller.performSegue(withIdentifier: id, sender: sender)
        }
      }
      builder.controllers.append(chapter)
      return builder
    }
  }
}
