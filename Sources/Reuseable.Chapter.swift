//
//  Reuseable.Chapter.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Chapter {
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

extension Array where Element == Reuseable.Chapter {

  internal func registerUniqueReuseIds
    ( _ register: (Reuseable.Chapter) throws -> Void
    ) throws {
    _ = try self.reduce(into: [String:Void]()) { dict, chapter in
      guard dict[chapter.reuseId] == nil else {
        // If you need many model to one view relation try to register same view with different reuse identifiers
        throw NotUniqueReuseId(id: chapter.reuseId)
      }
      try register(chapter)
      dict[chapter.reuseId] = ()
    }
  }

  internal func uniqueModelContexts() throws -> [String: Reuseable.Brief] {
    return try self.reduce(into: [:]) { dict, chapter in
      let key = String(reflecting: chapter.contextType)
      guard dict[key] == nil else { throw NotUniqueModel(type: chapter.contextType) }
      dict[key] = .init(reuseId: chapter.reuseId, configure: chapter.configure)
    }
  }
}

extension UITableView {

  internal func registerCell
    ( chapter: Reuseable.Chapter
    ) throws {
    switch chapter.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forCellReuseIdentifier: chapter.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forCellReuseIdentifier: chapter.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forCellReuseIdentifier: chapter.reuseId) }
    case .storyboard:
      break
    }
  }

  internal func registerView
    ( chapter: Reuseable.Chapter
    ) throws {
    switch chapter.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forHeaderFooterViewReuseIdentifier: chapter.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forHeaderFooterViewReuseIdentifier: chapter.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forHeaderFooterViewReuseIdentifier: chapter.reuseId) }
    case .storyboard:
      break
    }
  }
}

extension UICollectionView {

  internal func registerCell
    ( chapter: Reuseable.Chapter
    ) throws {
    switch chapter.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forCellWithReuseIdentifier: chapter.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws{ self.register(UINib(nibName: name, bundle: bundle), forCellWithReuseIdentifier: chapter.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forCellWithReuseIdentifier: chapter.reuseId) }
    case .storyboard:
      break
    }
  }

  internal func registerView
    ( kind: String
    , chapter: Reuseable.Chapter
    ) throws {
    switch chapter.source {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: chapter.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: chapter.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: chapter.reuseId) }
    case .storyboard:
      break
    }
  }
}
