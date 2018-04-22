//
//  Configuration.CollectionView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Configuration.CollectionView {
  
  public func cell
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionViewCell
  {
    do {
      try checkSameInstance(collectionView, cv)
      let key = try makeKey(context)
      guard let configurator = cells[key] else { throw Errors.NotRegistered(key: key) }
      let cell = try objc_throws { cv.dequeueReusableCell(withReuseIdentifier: configurator.reuseId, for: ip) }
      try configurator.configure(cell, context)
      return cell
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func hasHeader
    ( for context: Any
    ) -> Bool
  {
    guard let key = try? makeKey(context) else {return false}
    return supplementaries[UICollectionElementKindSectionHeader]?[key] != nil
  }

  public func header
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView
  {
    do {
      try checkSameInstance(collectionView, cv)
      let key = try makeKey(context)
      guard let config = supplementaries[UICollectionElementKindSectionHeader]?[key] else {
        throw Errors.NotRegistered(key: key)
      }
      let view = try objc_throws {
        cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: config.reuseId, for: ip)
      }
      try config.configure(view, context)
      return view
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func hasFooter
    ( for context: Any
    ) -> Bool
  {
    guard let key = try? makeKey(context) else {return false}
    return supplementaries[UICollectionElementKindSectionFooter]?[key] != nil
  }

  public func footer
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView
  {
    do {
      try checkSameInstance(collectionView, cv)
      let key = try makeKey(context)
      guard let config = supplementaries[UICollectionElementKindSectionFooter]?[key] else {
        throw Errors.NotRegistered(key: key)
      }
      let view = try objc_throws {
        cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: config.reuseId, for: ip)
      }
      try config.configure(view, context)
      return view
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func supplementary
    ( from cv: UICollectionView
    , of kind: String
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView
  {
    do {
      try checkSameInstance(collectionView, cv)
      let key = try makeKey(context)
      guard let config = supplementaries[kind]?[key] else {
        throw Errors.NotRegistered(key: key)
      }
      let view = try objc_throws {
        cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: config.reuseId, for: ip)
      }
      try config.configure(view, context)
      return view
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  internal init
    ( _ builder: Reuseable.Builder<UICollectionView>
    ) throws
  {
    self.collectionView = builder.built
    try builder.cells.registerUniqueReuseIds(builder.built.registerCell(brief:))
    cells = try builder.cells.uniqueModelContexts()
    supplementaries = try builder.supplementaries.reduce(into: [:]) { result, views in
      try views.value.registerUniqueReuseIds { try builder.built.registerView(kind: views.key, brief: $0) }
      result[views.key] = try views.value.uniqueModelContexts()
    }
  }
}
