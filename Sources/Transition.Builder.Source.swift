//
//  Transition.Builder.Source.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source {
  
  public func make
    ( factory: @escaping Transit.Make
    ) -> Transit {
    return .init(source: self, make: factory)
  }

  public func instantiateInitial
    ( storyboardName: String = Target.conventional.exclusiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    ) -> Transit {
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
    ( storyboardName: String = Target.conventional.collectiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    , storyboardId: String = Target.conventional.collectiveStoryboardIdentifier
    ) -> Transit {
    return make {
      let controller = try objc_throws {
        UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: storyboardId)
      }
      guard let container = controller as? Container else {
        throw Temp.error
      }
      return container
    }
  }
}

extension Transition.Builder.Source where Built: UIViewController {

  public func storyboardSegue
    ( segueId: String = Target.conventional.storyboardSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, UIStoryboardSegue>.Configurator {
    return .init(built: builder.built) { _, configure in
      var builder = self.builder
      let extract = self.extract
      let brief = Transition.Brief.Seguer(destinationType: Container.self, segueId: segueId) { segue, sender in
        guard let segue = segue as? UIStoryboardSegue else { throw Temp.error }
        guard let container = segue.destination as? Container else { throw Temp.error }
        let target = try extract(container)
        try configure(target, sender)
      }
      builder.seguers.append(brief)
      return builder
    }
  }

  public func embeddSegue
    ( segueId: String = Target.conventional.embeddSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, UIStoryboardSegue>.Configurator {
    return storyboardSegue(segueId: segueId)
  }

  public func manualSegue
    ( segueId: String = Target.conventional.storyboardSegueIdentifier
    ) -> Configurator {
    return .init(built: builder.built) { contextType, configure in
      var builder = self.builder
      let extract = self.extract
      let brief = Transition.Brief.Transiter(contextType: contextType) { controller, context in
        guard let controller = controller as? Built else { throw Temp.error }
        let sender = Transition.Brief.Seguer.Sender { segue in
          guard let container = segue.destination as? Container else { throw Temp.error }
          let target = try extract(container)
          try configure(target, context)
        }
        try objc_throws {
          controller.performSegue(withIdentifier: segueId, sender: sender)
        }
      }
      builder.transiters.append(brief)
      return builder
    }
  }
}
