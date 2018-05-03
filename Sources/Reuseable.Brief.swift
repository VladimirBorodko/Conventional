//
//  Reuseable.Brief.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Brief {

  internal init<T,View: AnyObject>
    ( configurator: Reuseable.Builder<T>.Registrator<View>.Configurator
    , contextType: Any.Type
    , configure: @escaping Reuseable.Configure
    )
  {
    self.viewType = View.self
    self.source = configurator.source
    self.reuseId = configurator.reuseId
    self.contextType = contextType
    self.configure = configure
  }

  internal init
    ( contextType: Any.Type
    , source: Reuseable.Source
    )
  {
    self.viewType = UIView.self
    self.source = source
    self.reuseId = ""
    self.contextType = contextType
    self.configure = { _, _ in }
  }

}

internal func dequeueTableCell
  ( brief: Reuseable.Brief
  ) -> Configuration.TableView.CellFactory
{
  let reuseId = brief.reuseId
  let configure = brief.configure
  return { tv, ip, ctx in
    return Flare(())
      .map { _ in
        try objc_throws { tv.dequeueReusableCell(withIdentifier: reuseId, for: ip) }
      }
      .perform { cell in
        try configure(cell, ctx)
      }
  }
}

internal func dequeueTableSupplementary
  ( brief: Reuseable.Brief
  ) -> Configuration.TableView.SupplementaryFactory
{
  let configure = brief.configure
  switch brief.source {
  case let .provide(factory):
    return { _, ctx in
      return Flare(())
        .map { _ in try factory(ctx) }
    }
  default:
    let reuseId = brief.reuseId
    let viewType: AnyClass = brief.viewType
    return { tv, ctx in
      return Flare(())
        .map { _ in
          try objc_throws { tv.dequeueReusableHeaderFooterView(withIdentifier: reuseId) }
        }
        .perform { view in
          guard let view = view else { throw Errors.UnwrapFailed(type: viewType) }
          try configure(view, ctx)
        }
    }
  }
}

internal func dequeueCollectionCell
  ( brief: Reuseable.Brief
  ) -> Configuration.CollectionView.CellFactory
{
  let reuseId = brief.reuseId
  let configure = brief.configure
  return { cv, ip, ctx in
    return Flare(())
      .map { _ in  try objc_throws { cv.dequeueReusableCell(withReuseIdentifier: reuseId, for: ip) } }
      .perform { cell in try configure(cell, ctx) }
  }
}

internal func dequeueCollectionSupplementary
  ( brief: Reuseable.Brief
  ) -> Configuration.CollectionView.SupplementaryFactory
{
  let reuseId = brief.reuseId
  let configure = brief.configure
  return { cv, kind, ip, ctx in
    return Flare(())
      .map { _ in  try objc_throws { cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseId, for: ip) } }
      .perform { view in try configure(view, ctx) }
  }
}

extension Array where Element == Reuseable.Brief {

  internal func registerUniqueReuseIds
    ( _ register: (Reuseable.Brief) throws -> Void
    ) -> Flare<Void>
  {
    return self
      .reduce(Flare<[String:Void]>([:])) { flare, brief in
        flare.perform { dict in
          if case .provide = brief.source { return }
          guard dict[brief.reuseId] == nil else { throw Errors.NotUnique(key: brief.reuseId) }
          try register(brief)
          dict[brief.reuseId] = ()
        }
      }.map { _ in }
  }

  internal func uniqueModelContexts<T>
    ( _ transform: (Reuseable.Brief) -> T
    ) -> Flare<[String: T]>
  {
    return self.reduce(Flare<[String: T]>([:])) { flare, brief in
      let key = String(reflecting: brief.contextType)
      return flare.perform { dict in
        guard dict[key] == nil else { throw Errors.NotUnique(key: key) }
        dict[key] = transform(brief)
      }
    }
  }
}

extension UITableView {

  internal func registerCell
    ( brief: Reuseable.Brief
    ) throws
  {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forCellReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forCellReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forCellReuseIdentifier: brief.reuseId) }
    default: break
    }
  }

  internal func registerView
    ( brief: Reuseable.Brief
    ) throws
  {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    default: break
    }
  }
}

extension UICollectionView {

  internal func registerCell
    ( brief: Reuseable.Brief
    ) throws
  {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forCellWithReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws{ self.register(UINib(nibName: name, bundle: bundle), forCellWithReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forCellWithReuseIdentifier: brief.reuseId) }
    default: break
    }
  }

  internal func registerView
    ( kind: String
    , brief: Reuseable.Brief
    ) throws
  {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: brief.reuseId) }
    default: break
    }
  }
}
