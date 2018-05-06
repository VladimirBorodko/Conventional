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
    return Flare(context)
      .perform { _ in try checkSameInstance(source, cv) }
      .map(Hashes.Context.init(context:))
      .map(cells.value)
      .flatMap { $0(cv, ip, context) }
      .unwrap(file, line)
  }

  public func hasHeader
    ( for context: Any
    ) -> Bool
  { return nil != (try? supplementaries.value(for: .header(for: context))) }

  public func header
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UICollectionReusableView
  { return supplementary(from: cv, of: UICollectionElementKindSectionHeader, at: ip, for: context, file: file, line: line) }

  public func hasFooter
    ( for context: Any
    ) -> Bool
  { return nil != (try? supplementaries.value(for: .footer(for: context))) }

  public func footer
    ( from cv: UICollectionView
    , at ip: IndexPath
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UICollectionReusableView
  { return supplementary(from: cv, of: UICollectionElementKindSectionFooter, at: ip, for: context, file: file, line: line) }

  public func supplementary
    ( from cv: UICollectionView
    , of kind: String
    , at ip: IndexPath
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UICollectionReusableView
  {
    return Flare(context)
      .perform { _ in try checkSameInstance(source, cv) }
      .map(kind.supplementaryKey)
      .map(supplementaries.value)
      .map(unwrap)
      .flatMap { $0(cv, kind, ip, context) }
      .unwrap(file, line)
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
