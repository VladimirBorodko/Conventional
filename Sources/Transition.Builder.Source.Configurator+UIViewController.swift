//
//  Transition.Builder.Source.Configurator+UIViewController.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source.Configurator where Container: UIViewController {
  
  public func configure<Context>
    ( with _: Context.Type
    , by closure: @escaping (Built) -> (Target, Context) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }

  public func configure<Context>
    ( with _: Context.Type
    , by closure: @escaping (Built, Target, Context) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }

  public func configure<Context>
    ( with _: Context.Type
    , by closure: @escaping (Target) -> (Context) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }

  public func configure<Context, Router>
    ( with _: Context.Type
    , router: Router
    , by closure: @escaping (Router) -> (Built, Target, Context) -> Void
    ) -> Transition.Builder<Built> {
    return Transition.Builder<Built>?(nilLiteral: ())!
  }
}
