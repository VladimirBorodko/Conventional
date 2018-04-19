//
//  Reuseable.Builder+UITableView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Builder where T == UITableView {
  
  public func cell<View: UITableViewCell>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { chapter in
      var compound = self
      compound.cells.append(chapter)
      return compound
    }
  }

  public func header<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { chapter in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionHeader] = compound.headers + [chapter]
      return compound
    }
  }

  public func footer<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { chapter in
      var compound = self
      compound.supplementaries[UICollectionElementKindSectionFooter] = compound.footers + [chapter]
      return compound
    }
  }

  public func build() -> TableViewStock {
    do {
      return try .init(self)
    } catch let e {
      fatalError("\(e)")
    }
  }
}
