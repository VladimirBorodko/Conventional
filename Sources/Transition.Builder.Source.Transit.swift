//
//  Transition.Builder.Source.Transiter.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source.Transit {

  public func customTransit
    ( by perform: @escaping (Built, Container) throws -> Void
    ) -> Transition.Builder<Built>.Source<Target, Container>.Configurator
  {
    var builder = source.builder
    let extract = source.extract
    let make = self.make
    return .init(built: source.builder.built) { contextType, configure in
      let brief = Transition.Brief.Transiter(contextType: contextType) { controller, context in
        let controller = try cast(controller, Built.self)
        let container = try make()
        let target = try extract(container)
        try configure(target, context)
        try perform(controller, container)
      }
      builder.transiters.append(brief)
      return builder
    }
  }
}

extension Transition.Builder.Source.Transit where Container: UIViewController {

  public func provide
    () -> Transition.Builder<Built>.Source<Target, Container>.Configurator
  {
    var builder = source.builder
    let extract = source.extract
    let make = self.make
    return .init(built: source.builder.built) { contextType, configure in
      let brief = Transition.Brief.Provider(contextType: contextType) { context in
        let container = try make()
        let target = try extract(container)
        try configure(target, context)
        return container
      }
      builder.providers.append(brief)
      return builder
    }
  }

}

extension Transition.Builder.Source.Transit where Built: UIViewController, Container: UIViewController {

  public func show
    () -> Transition.Builder<Built>.Source<Target, Container>.Configurator
  {
    return customTransit { built, container in
      built.show(container, sender: built)
    }
  }
}

extension Transition.Builder.Source.Transit where Built: UIWindow, Container: UIViewController {

  public func changeRoot
    ( duration: TimeInterval = Target.conventional.transitionDuration
    , options: UIViewAnimationOptions = Target.conventional.transitionOptions
    ) -> Transition.Builder<Built>.Source<Target, Container>.Configurator
  {
    return customTransit { built, container in
      if built.rootViewController == nil {
        built.rootViewController = container
        built.makeKeyAndVisible()
        return
      }
      UIView.transition(with: built, duration: duration, options: options, animations: { built.rootViewController = container }, completion: nil)
    }
  }
}
