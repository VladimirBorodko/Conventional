//
//  Compound.CollectionView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Compound.CollectionView {
  
  public func cell
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionViewCell {
    do {
      guard cv === collectionView else { throw WrongViewInstance(view: cv) }
      guard let configurator = try cells[key(context)] else { throw Temp.error }
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
    ) -> Bool {
    guard let key = try? key(context) else {return false}
    return supplementaries[UICollectionElementKindSectionHeader]?[key] != nil
  }

  public func header
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView {
    do {
      guard cv === collectionView else {throw WrongViewInstance(view: cv)}
      guard let config = try supplementaries[UICollectionElementKindSectionHeader]?[key(context)] else {
        throw Temp.error
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
    ) -> Bool {
    guard let key = try? key(context) else {return false}
    return supplementaries[UICollectionElementKindSectionFooter]?[key] != nil
  }

  public func footer
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UICollectionReusableView {
    do {
      guard cv === collectionView else {throw WrongViewInstance(view: cv)}
      guard let config = try supplementaries[UICollectionElementKindSectionFooter]?[key(context)] else {
        throw Temp.error
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
    ) throws -> UICollectionReusableView {
    do {
      guard cv === collectionView else {throw WrongViewInstance(view: cv)}
      guard let config = try supplementaries[kind]?[key(context)] else {
        throw Temp.error
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
    ) throws {
    self.collectionView = builder.built
    try builder.cells.registerUniqueReuseIds(builder.built.registerCell(brief:))
    cells = try builder.cells.uniqueModelContexts()
    supplementaries = try builder.supplementaries.reduce(into: [:]) { result, views in
      try views.value.registerUniqueReuseIds { try builder.built.registerView(kind: views.key, brief: $0) }
      result[views.key] = try views.value.uniqueModelContexts()
    }
  }
}
