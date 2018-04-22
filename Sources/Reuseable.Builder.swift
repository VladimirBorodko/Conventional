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
      var compound = self
      compound.cells.append(brief)
      return compound
    }
  }

  public func header<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionHeader] = compound.headers + [brief]
      return compound
    }
  }

  public func footer<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionFooter] = compound.footers + [brief]
      return compound
    }
  }

  public func supplementary<View: UICollectionReusableView>
    ( _: View.Type
    , of kind: String
    ) -> Registrator<View> {
    return .init { brief in
      var compound = self
      compound.supplementaries[kind] = (compound.supplementaries[kind] ?? []) + [brief]
      return compound
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
      var compound = self
      compound.cells.append(brief)
      return compound
    }
  }

  public func header<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionHeader] = compound.headers + [brief]
      return compound
    }
  }

  public func footer<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionFooter] = compound.footers + [brief]
      return compound
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
