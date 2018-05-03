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
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UICollectionViewCell
  {
    return Flare(context, file: file, line : line)
      .perform { _ in try checkSameInstance(source, cv) }
      .map(makeKey)
      .map { try cells[$0].unwrap(Errors.NotRegistered(key: $0)) }
      .flatMap { $0(cv, ip, context) }
      .unwrap()
//    do {
//      try checkSameInstance(source, cv)
//      let key = try makeKey(context)
//      guard let configurator = cells[key] else { throw Errors.NotRegistered(key: key) }
//      let cell = try objc_throws { cv.dequeueReusableCell(withReuseIdentifier: configurator.reuseId, for: ip) }
//      try configurator.configure(cell, context)
//      return cell
//    } catch let e {
//      assertionFailure("\(e)")
//      throw e
//    }
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
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UICollectionReusableView
  {
    return Flare(context, file: file, line : line)
      .perform { _ in try checkSameInstance(source, cv) }
      .map(makeKey)
      .map { key in
        try supplementaries[UICollectionElementKindSectionHeader]
          .flatMap {$0[key]}
          .unwrap(Errors.NotRegistered(key: key))
      }.flatMap { $0(cv, UICollectionElementKindSectionHeader, ip, context) }
      .unwrap()
//    do {
//      try checkSameInstance(source, cv)
//      let key = try makeKey(context)
//      guard let config = supplementaries[UICollectionElementKindSectionHeader]?[key] else {
//        throw Errors.NotRegistered(key: key)
//      }
//      let view = try objc_throws {
//        cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: config.reuseId, for: ip)
//      }
//      try config.configure(view, context)
//      return view
//    } catch let e {
//      assertionFailure("\(e)")
//      throw e
//    }
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
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UICollectionReusableView
  {
    return Flare(context, file: file, line : line)
      .perform { _ in try checkSameInstance(source, cv) }
      .map(makeKey)
      .map { key in
        try supplementaries[UICollectionElementKindSectionFooter]
          .flatMap {$0[key]}
          .unwrap(Errors.NotRegistered(key: key))
      }.flatMap { $0(cv, UICollectionElementKindSectionFooter, ip, context) }
      .unwrap()
//    do {
//      try checkSameInstance(source, cv)
//      let key = try makeKey(context)
//      guard let config = supplementaries[UICollectionElementKindSectionFooter]?[key] else {
//        throw Errors.NotRegistered(key: key)
//      }
//      let view = try objc_throws {
//        cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: config.reuseId, for: ip)
//      }
//      try config.configure(view, context)
//      return view
//    } catch let e {
//      assertionFailure("\(e)")
//      throw e
//    }
  }

  public func supplementary
    ( from cv: UICollectionView
    , of kind: String
    , at ip: IndexPath
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UICollectionReusableView
  {
    return Flare(context, file: file, line : line)
      .perform { _ in try checkSameInstance(source, cv) }
      .map(makeKey)
      .map { key in
        try supplementaries[kind]
          .flatMap {$0[key]}
          .unwrap(Errors.NotRegistered(key: key))
      }.flatMap { $0(cv, kind, ip, context) }
      .unwrap()
//    do {
//      try checkSameInstance(source, cv)
//      let key = try makeKey(context)
//      guard let config = supplementaries[kind]?[key] else {
//        throw Errors.NotRegistered(key: key)
//      }
//      let view = try objc_throws {
//        cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: config.reuseId, for: ip)
//      }
//      try config.configure(view, context)
//      return view
//    } catch let e {
//      assertionFailure("\(e)")
//      throw e
//    }
  }

  internal init
    ( _ source: UICollectionView
    )
  {
    self.source = source
    self.cells = [:]
    self.supplementaries = [:]
  }
}
