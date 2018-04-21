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
      let contextType = type(of: context)
      guard cv === collectionView else { throw WrongViewInstance(view: cv) }
      guard let configurator = cells[String(reflecting: contextType)] else { throw NotRegisteredContext(type: contextType) }
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
      assertionFailure("\(e)")
      throw e
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
      assertionFailure("\(e)")
      throw e
    }
  }
}
