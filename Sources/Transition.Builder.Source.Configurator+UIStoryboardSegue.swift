//
//  Transition.Builder.Source.Configurator+UIStoryboardSegue.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source.Configurator where Container == UIStoryboardSegue {

  public func configure
    ( by closure: @escaping (Built) -> (Target, _ sender: Any) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }

  public func configure
    ( by closure: @escaping (Built, Target, _ sender: Any) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }

  public func configure<Router>
    ( router: Router
    , by closure: @escaping (Router) -> (Built, Target, _ sender: Any) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }
  
  public func configure<Router>
    ( router: Router
    , by closure: @escaping (Router) -> (Target) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }

}
