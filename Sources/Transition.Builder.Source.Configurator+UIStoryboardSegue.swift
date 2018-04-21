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
    return apply(Any.self) { [weak built = self.built] target, sender in
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      closure(built)(target, sender)
    }
  }

  public func configure
    ( by closure: @escaping (Built, Target, _ sender: Any) -> Void
    ) -> Transition.Builder<Built> {
    return apply(Any.self) { [weak built = self.built] target, sender in
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      closure(built, target, sender)
    }
  }

  public func configure<Router: AnyObject>
    ( by router: Router
    , with closure: @escaping (Router) -> (Built, Target, _ sender: Any) -> Void
    ) -> Transition.Builder<Built> {
    return apply(Any.self) { [weak router, weak built = self.built] target, sender in
      guard let router = router else { throw Temp.error }
      guard let built = built else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      closure(router)(built, target, sender)
    }
  }
  
  public func configure<Router: AnyObject>
    ( by router: Router
    , with closure: @escaping (Router) -> (Target) -> Void
    ) -> Transition.Builder<Built> {
    return apply(Any.self) { [weak router] target, sender in
      guard let router = router else { throw Temp.error }
      guard let target = target as? Target else { throw Temp.error }
      closure(router)(target)
    }
  }

}
