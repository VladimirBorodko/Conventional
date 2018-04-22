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
    ) {
    self.viewType = View.self
    self.source = configurator.source
    self.reuseId = configurator.reuseId
    self.contextType = contextType
    self.configure = configure
  }
}

extension Array where Element == Reuseable.Brief {

  internal func registerUniqueReuseIds
    ( _ register: (Reuseable.Brief) throws -> Void
    ) throws {
    _ = try self.reduce(into: [String:Void]()) { dict, brief in
      guard dict[brief.reuseId] == nil else { throw Errors.NotUnique(key: brief.reuseId) }
      try register(brief)
      dict[brief.reuseId] = ()
    }
  }

  internal func uniqueModelContexts() throws -> [String: Reuseable] {
    return try self.reduce(into: [:]) { dict, brief in
      let key = String(reflecting: brief.contextType)
      guard dict[key] == nil else { throw Errors.NotUnique(key: key) }
      dict[key] = .init(reuseId: brief.reuseId, configure: brief.configure)
    }
  }
}

extension UITableView {

  internal func registerCell
    ( brief: Reuseable.Brief
    ) throws {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forCellReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forCellReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forCellReuseIdentifier: brief.reuseId) }
    case .storyboard:
      break
    }
  }

  internal func registerView
    ( brief: Reuseable.Brief
    ) throws {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case .storyboard:
      break
    }
  }
}

extension UICollectionView {

  internal func registerCell
    ( brief: Reuseable.Brief
    ) throws {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forCellWithReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws{ self.register(UINib(nibName: name, bundle: bundle), forCellWithReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forCellWithReuseIdentifier: brief.reuseId) }
    case .storyboard:
      break
    }
  }

  internal func registerView
    ( kind: String
    , brief: Reuseable.Brief
    ) throws {
    switch brief.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: brief.reuseId) }
    case .storyboard:
      break
    }
  }
}
