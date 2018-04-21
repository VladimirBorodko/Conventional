//
//  Compound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import Foundation

public enum Compound {

  public final class CollectionView {
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
  }

  public final class TableView {

    internal let cells: [String: Reuseable.Brief]
    internal let headers: [String: Reuseable.Brief]
    internal let footers: [String: Reuseable.Brief]
    internal weak var tableView: UITableView?

    internal init
      ( _ builder: Reuseable.Builder<UITableView>
      ) throws {
      self.tableView = builder.view
      try builder.cells.registerUniqueReuseIds(builder.view.registerCell(chapter:))
      cells = try builder.cells.uniqueModelContexts()
      try builder.supplementaries.values.reduce(into: [], +=).registerUniqueReuseIds(builder.view.registerView(chapter:))
      headers = try builder.headers.uniqueModelContexts()
      footers = try builder.footers.uniqueModelContexts()
    }
  }

  public class ViewController {
    internal weak var source: UIViewController?
    internal init
      ( _ builder: Transition.Builder<UIViewController>
      ) throws {
      source = builder.built
    }
  }

  public class Window {
    internal weak var source: UIWindow?
    internal init
      ( _ builder: Transition.Builder<UIWindow>
      ) throws {
      source = builder.built
    }
  }
}
