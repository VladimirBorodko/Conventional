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
    ) -> Transit
  { return .init(source: self, make: factory) }

  public func instantiateInitial
    ( storyboardName: String = Target.conventional.exclusiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    ) -> Transit
  {
    return make {
      let controller = try objc_throws {
        UIStoryboard(name: storyboardName, bundle: bundle).instantiateInitialViewController()
      }
      return try cast(controller, Container.self)
    }
  }

  public func instantiate
    ( storyboardName: String = Target.conventional.collectiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    , storyboardId: String = Target.conventional.collectiveStoryboardIdentifier
    ) -> Transit
  {
    return make {
      let controller = try objc_throws {
        UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: storyboardId)
      }
      return try cast(controller, Container.self)
    }
  }
}

extension Transition.Builder.Source where Built: UIViewController {

  public func storyboardSegue
    ( segueId: String = Target.conventional.storyboardSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, UIStoryboardSegue>.Configurator
  {
    return .init(built: builder.built) { _, configure in
      var builder = self.builder
      let extract = self.extract
      let brief = Transition.Brief.segue(segueId, Container.self) { segue, sender in
        return Flare(segue)
          .map { try cast($0, UIStoryboardSegue.self) }
          .map { try cast($0.destination, Container.self) }
          .map { try configure(extract($0), sender).escalate() }
      }
      builder.briefs.append(brief)
      return builder
    }
  }

  public func embeddSegue
    ( segueId: String = Target.conventional.embeddSegueIdentifier
    ) -> Transition.Builder<Built>.Source<Target, UIStoryboardSegue>.Configurator
  { return storyboardSegue(segueId: segueId) }

  public func manualSegue
    ( segueId: String = Target.conventional.storyboardSegueIdentifier
    ) -> Configurator
  {
    return .init(built: builder.built) { contextType, configure in
      var builder = self.builder
      let extract = self.extract
      let brief = Transition.Brief.transit(contextType) { context in
        let sender = Transition.Sender { segue in return Flare(segue)
          .map { try cast($0.destination, Container.self) }
          .map { try configure(extract($0), context).escalate() }
        }
        return Flare(context)
          .map { context in
            return Transition { built in
              return Flare(built)
                .map { try cast($0, Built.self) }
                .map { built in
                  try objc_throws {
                    built.performSegue(withIdentifier: segueId, sender: sender)
                  }
                }
            }
          }
      }
      builder.briefs.append(brief)
      return builder
    }
  }
}
