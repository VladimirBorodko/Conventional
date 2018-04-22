//
//  Transition.Builder.Source.Configurator.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder.Source.Configurator {

  public func noContext() -> Transition.Builder<Built> {
    return apply(Target.self) { _, _ in}
  }
}

extension Transition.Builder.Source.Configurator where Container == UIStoryboardSegue {

  public func customConfigure
    ( by closure: @escaping (Built, Target, _ sender: Any) throws -> Void
    ) -> Transition.Builder<Built> {
    return apply(Any.self) { [weak built = self.built]  target, sender in
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      try closure(built, target, sender)
    }
  }

  public func configure
    ( by closure: @escaping (Built) -> (Target, _ sender: Any) -> Void
    ) -> Transition.Builder<Built> {
    return customConfigure { built, target, sender in
      closure(built)(target, sender)
    }
  }

  public func configure<Router: AnyObject>
    ( by router: Router
    , with closure: @escaping (Router) -> (Built, Target, _ sender: Any) -> Void
    ) -> Transition.Builder<Built> {
    return customConfigure { [weak router] built, target, sender in
      guard let router = router else { throw Temp.error }
      closure(router)(built, target, sender)
    }
  }
  
  public func configure<Router: AnyObject>
    ( by router: Router
    , with closure: @escaping (Router) -> (Target) -> Void
    ) -> Transition.Builder<Built> {
    return customConfigure { [weak router] _, target, sender in
      guard let router = router else { throw Temp.error }
      closure(router)(target)
    }
  }
}

extension Transition.Builder.Source.Configurator where Container: UIViewController {

  public func customConfigure<Context>
    ( _ contextType: Context.Type
    , with closure: @escaping (Built, Target, Context) throws -> Void
    ) -> Transition.Builder<Built> {
    return apply(Context.self) { [weak built = self.built] target, context in
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      guard let context = context as? Context else { throw Temp.error }
      try closure(built, target, context)
    }
  }

  public func configure<Context>
    ( with closure: @escaping (Built) -> (Target, Context) -> Void
    ) -> Transition.Builder<Built> {
    return customConfigure(Context.self) { built, target, context in
      closure(built)(target, context)
    }
  }

  public func configure<Context>
    ( with closure: @escaping (Target) -> (Context) -> Void
    ) -> Transition.Builder<Built> {
    return customConfigure(Context.self) { _, target, context in
      closure(target)(context)
    }
  }

  public func configure<Context, Router: AnyObject>
    ( by router: Router
    , with closure: @escaping (Router) -> (Built, Target, Context) -> Void
    ) -> Transition.Builder<Built> {
    return customConfigure(Context.self) { [weak router] built, target, context in
      guard let router = router else { throw Temp.error }
      closure(router)(built, target, context)
    }
  }
}
