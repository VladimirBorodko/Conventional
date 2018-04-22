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
    ) throws -> Transition.Builder<Built>.Source<Target, Container>.Configurator {
    return .init(built: source.builder.built) { contextType, configure in
      var builder = self.source.builder
      let extract = self.source.extract
      let make = self.make
      let brief = Transition.Brief.Transiter(contextType: contextType) { controller, context in
        guard let controller = controller as? Built else { throw Temp.error }
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

  public func provide() -> Transition.Builder<Built>.Source<Target, Container>.Configurator {
    return .init(built: source.builder.built) { contextType, configure in
      var builder = self.source.builder
      let extract = self.source.extract
      let make = self.make
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

extension Transition.Builder.Source.Transit where Built: UIViewController {

}

extension Transition.Builder.Source.Transit where Built: UIWindow {

}
