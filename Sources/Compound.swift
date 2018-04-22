//
//  Compound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import Foundation

public enum Compound {

  public struct CollectionView {

    internal let cells: [String: Reuseable]
    internal let supplementaries: [String: [String: Reuseable]]
    internal weak var collectionView: UICollectionView?
  }

  public struct TableView {

    internal let cells: [String: Reuseable]
    internal let headers: [String: Reuseable]
    internal let footers: [String: Reuseable]
    internal weak var tableView: UITableView?
  }

  public struct ViewController {

    internal weak var source: UIViewController?
    internal let segues: [Transition.Brief.Seguer.Key: Transition.Configure]
    internal let provider: Converter<UIViewController>
    public let transiter: Converter<Transition>
  }

  public struct Window {

    internal weak var source: UIWindow?
    public let transiter: Converter<Transition>
  }
}
