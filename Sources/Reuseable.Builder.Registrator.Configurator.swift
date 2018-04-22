//
//  Reuseable.Builder.Registrator.Configurator.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Builder.Registrator.Configurator {

  public func customConfigure<Context>
    ( _ contextType: Context.Type
    , by closure: @escaping (View, Context) throws -> Void
    ) -> Reuseable.Builder<Built>
  {
    let brief = Reuseable.Brief(configurator: self, contextType: Context.self) { view, context in
      let view = try cast(view, View.self)
      let context = try cast(context, Context.self)
      try closure(view,context)
    }
    return registrator.apply(brief)
  }

  public func configure<Context, Owner: AnyObject>
    ( by owner: Owner
    , with closure: @escaping (Owner) -> (View, Context) -> Void
    ) -> Reuseable.Builder<Built>
  {
    return customConfigure(Context.self) { [weak owner] view, context in
      let owner = try unwrap(owner)
      closure(owner)(view,context)
    }
  }

  public func configure<Context>
    ( with closure: @escaping (View) -> (Context) -> Void
    ) -> Reuseable.Builder<Built>
  {
    return customConfigure(Context.self) { view, context in
      closure(view)(context)
    }
  }

  public func noContext
    () -> Reuseable.Builder<Built>
  { return customConfigure(View.self) { _, _ in } }
}
