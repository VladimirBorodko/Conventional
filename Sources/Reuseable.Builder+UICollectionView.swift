//
//  Reuseable.Builder+UICollectionView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Builder where T == UICollectionView {

  public func cell<View: UICollectionViewCell>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { chapter in
      var compound = self
      compound.cells.append(chapter)
      return compound
    }
  }

  public func header<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { chapter in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionHeader] = compound.headers + [chapter]
      return compound
    }
  }

  public func footer<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { chapter in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionFooter] = compound.footers + [chapter]
      return compound
    }
  }

  public func supplementary<View: UICollectionReusableView>
    ( _: View.Type
    , of kind: String
    ) -> Registrator<View> {
    return .init { chapter in
      var compound = self
      compound.supplementaries[kind] = (compound.supplementaries[kind] ?? []) + [chapter]
      return compound
    }
  }

  public func build() -> CollectionViewStock {
    do {
      return try .init(self)
    } catch let e {
      fatalError("\(e)")
    }
  }
}
