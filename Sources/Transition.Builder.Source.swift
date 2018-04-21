//
//  Transition.Builder.Source.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source {
  
  public func make
    ( factory: @escaping Transit.Factory
    ) -> Transition.Builder<Built>.Source<Target, Container>.Transit {
    return .init(source: self, factory: factory)
  }

  public func instantiateInitial
    ( from storyboardName: String = Target.conventional.exclusiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    ) -> Transition.Builder<Built>.Source<Target, Container>.Transit {
    return make {
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
    return make {
      let controller = try objc_throws {
        UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: id)
      }
      guard let container = controller as? Container else {
        throw Temp.error
      }
      return container
    }
  }
}

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

  public func embeddSegue
    ( with id: String = Target.conventional.embeddSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, UIStoryboardSegue>.Configurator {
    return storyboardSegue(with: id)
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
