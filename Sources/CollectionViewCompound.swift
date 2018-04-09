//
//  CollectionViewCompound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public final class CollectionViewCompound {

  let cells: [String: ReuseableBrief.Config]
  let supplementaries: [String: [String: ReuseableBrief.Config]]
  weak var collectionView: UICollectionView?

  init
    ( _ builder: ReuseableComposer<UICollectionView>
    ) throws {
    self.collectionView = builder.view
    try builder.cells.registerUniqueReuseIds(builder.view.registerCell(brief:))
    cells = try builder.cells.uniqueModelContexts()
    supplementaries = try builder.supplementaries.reduce(into: [:]) { result, views in
      try views.value.registerUniqueReuseIds { try builder.view.registerView(kind: views.key, brief: $0) }
      result[views.key] = try views.value.uniqueModelContexts()
    }
  }

  func cell
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) -> UICollectionViewCell {
    do {
      let contextType = type(of: context)
      guard cv === collectionView else { throw WrongViewInstance(view: cv) }
      guard let configurator = cells[String(reflecting: contextType)] else { throw NotRegisteredContext(type: contextType) }
      let cell = try objc_throws { cv.dequeueReusableCell(withReuseIdentifier: configurator.reuseId, for: ip) }
      try configurator.configure(cell, context)
      return cell
    } catch let e {
      preconditionFailure("\(e)")
    }
  }

  public func hasHeader
    ( for context: Any
    ) -> Bool {
    return supplementaries[UICollectionElementKindSectionHeader]?[String(reflecting: type(of: context))] != nil
  }

  public func header
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView {
    do {
      let contextType = type(of: context)
      guard cv === collectionView else {throw WrongViewInstance(view: cv)}
      guard let config = supplementaries[UICollectionElementKindSectionHeader]?[String(reflecting: contextType)] else {
        throw NotRegisteredContext(type: contextType)
      }
      let view = try objc_throws {
        cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: config.reuseId, for: ip)
      }
      try config.configure(view, context)
      return view
    } catch let e {
      preconditionFailure("\(e)")
    }
  }

  public func hasFooter
    ( for context: Any
    ) -> Bool {
    return supplementaries[UICollectionElementKindSectionFooter]?[String(reflecting: type(of: context))] != nil
  }

  public func footer
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView {
    do {
      let contextType = type(of: context)
      guard cv === collectionView else {throw WrongViewInstance(view: cv)}
      guard let config = supplementaries[UICollectionElementKindSectionFooter]?[String(reflecting: contextType)] else {
        throw NotRegisteredContext(type: contextType)
      }
      let view = try objc_throws {
        cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: config.reuseId, for: ip)
      }
      try config.configure(view, context)
      return view
    } catch let e {
      preconditionFailure("\(e)")
    }
  }

  public func supplementary
    ( from cv: UICollectionView
    , of kind: String
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView {
    do {
      let contextType = type(of: context)
      guard cv === collectionView else {throw WrongViewInstance(view: cv)}
      guard let config = supplementaries[kind]?[String(reflecting: contextType)] else {
        throw NotRegisteredContext(type: contextType)
      }
      let view = try objc_throws {
        cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: config.reuseId, for: ip)
      }
      try config.configure(view, context)
      return view
    } catch let e {
      preconditionFailure("\(e)")
    }
  }
}

private extension UICollectionView {

  func registerCell
    ( brief: ReuseableBrief
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

  func registerView
    ( kind: String
    , brief: ReuseableBrief
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
