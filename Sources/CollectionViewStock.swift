//
//  CollectionViewStock.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public final class CollectionViewStock {

  internal let cells: [String: Reuseable.Brief]
  internal let supplementaries: [String: [String: Reuseable.Brief]]
  internal weak var collectionView: UICollectionView?

  internal init
    ( _ builder: Reuseable.Builder<UICollectionView>
    ) throws {
    self.collectionView = builder.view
    try builder.cells.registerUniqueReuseIds(builder.view.registerCell(chapter:))
    cells = try builder.cells.uniqueModelContexts()
    supplementaries = try builder.supplementaries.reduce(into: [:]) { result, views in
      try views.value.registerUniqueReuseIds { try builder.view.registerView(kind: views.key, chapter: $0) }
      result[views.key] = try views.value.uniqueModelContexts()
    }
  }

  public func cell
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

