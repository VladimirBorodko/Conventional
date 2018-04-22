//
//  Transition.Builder.Source.Transit.swift
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
      let provide = self.provide
      let brief = Transition.Brief.Controller(contextType: contextType) { controller, context in
        guard let controller = controller as? Built else { throw Temp.error }
        let container = try provide()
        let target = try extract(container)
        try configure(target, context)
        try perform(controller, container)
      }
      builder.controllers.append(brief)
      return builder
    }
  }
}

extension Transition.Builder.Source.Transit where Built: UIViewController {

}

extension Transition.Builder.Source.Transit where Built: UIWindow {

}
