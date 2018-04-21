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
    return apply(Context.self) { [weak built = self.built] target, context in
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      guard let context = context as? Context else { throw Temp.error }
      closure(built)(target, context)
    }
  }

  public func configure<Context>
    ( with _: Context.Type
    , by closure: @escaping (Built, Target, Context) -> Void
    ) -> Transition.Builder<Built> {
    return apply(Context.self) { [weak built = self.built] target, context in
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      guard let context = context as? Context else { throw Temp.error }
      closure(built, target, context)
    }
  }

  public func configure<Context>
    ( with _: Context.Type
    , by closure: @escaping (Target) -> (Context) -> Void
    ) -> Transition.Builder<Built> {
    return apply(Context.self) { target, context in
      guard let target = target as? Target else { throw Temp.error }
      guard let context = context as? Context else { throw Temp.error }
      closure(target)(context)
    }
  }

  public func configure<Context, Router: AnyObject>
    ( with _: Context.Type
    , router: Router
    , by closure: @escaping (Router) -> (Built, Target, Context) -> Void
    ) -> Transition.Builder<Built> {
    return apply(Context.self) { [weak router, weak built = self.built] target, context in
      guard let router = router else { throw Temp.error }
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      guard let context = context as? Context else { throw Temp.error }
      closure(router)(built, target, context)
    }
  }
}
