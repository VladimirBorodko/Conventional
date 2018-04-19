//
//  Reuseable.Builder.Registrator.Configurator.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Builder.Registrator.Configurator {

  public func configure<Context, Owner: AnyObject>
    ( with _: Context.Type
    , owner: Owner
    , by closure: @escaping (Owner) -> (View, Context) -> Void
    ) -> Reuseable.Builder<T> {
    let chapter = Reuseable.Chapter(configurator: self, contextType: Context.self) { [weak owner] view, context in
      guard let owner = owner else { throw OwnerDeallocated<View>(configuratorType: Owner.self) }
      guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Context.self) }
      guard let context = context as? Context else { throw ModelTypeMismatch<View>(modelType: Context.self) }
      closure(owner)(view,context)
    }
    return registrator.add(chapter)
  }

  public func configure<Context>
    ( with _: Context.Type
    , by closure: @escaping (View, Context) -> Void
    ) -> Reuseable.Builder<T> {
    let chapter = Reuseable.Chapter(configurator: self, contextType: Context.self) { view, context in
      guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Context.self) }
      guard let context = context as? Context else { throw ModelTypeMismatch<View>(modelType: Context.self) }
      closure(view,context)
    }
    return registrator.add(chapter)
  }

  public func configure<Context>
    ( with _: Context.Type
    , by closure: @escaping (View) -> (Context) -> Void
    ) -> Reuseable.Builder<T> {
    let chapter = Reuseable.Chapter(configurator: self, contextType: Context.self) { view, context in
      guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Context.self) }
      guard let context = context as? Context else { throw ModelTypeMismatch<View>(modelType: Context.self) }
      closure(view)(context)
    }
    return registrator.add(chapter)
  }
}
