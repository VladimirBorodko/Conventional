//
//  Reuseable.Builder.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Builder {

  internal var headers: [Reuseable.Brief] {
    return supplementaries[UICollectionElementKindSectionHeader] ?? []
  }
  
  internal var footers: [Reuseable.Brief] {
    return supplementaries[UICollectionElementKindSectionFooter] ?? []
  }

  internal init
    ( _ built: Built
    ) {
    self.built = built
  }
}

extension Reuseable.Builder where Built == UICollectionView {

  public func cell<View: UICollectionViewCell>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.cells.append(brief)
      return builder
    }
  }

  public func header<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [brief]
      return builder
    }
  }

  public func footer<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [brief]
      return builder
    }
  }

  public func supplementary<View: UICollectionReusableView>
    ( _: View.Type
    , of kind: String
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[kind] = (builder.supplementaries[kind] ?? []) + [brief]
      return builder
    }
  }

  public func build() throws -> Compound.CollectionView {
    do {
      return try .init(self)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}

extension Reuseable.Builder where Built == UITableView {

  public func cell<View: UITableViewCell>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.cells.append(brief)
      return builder
    }
  }

  public func header<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [brief]
      return builder
    }
  }

  public func footer<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [brief]
      return builder
    }
  }

  public func build() throws -> Compound.TableView {
    do {
      return try .init(self)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}
