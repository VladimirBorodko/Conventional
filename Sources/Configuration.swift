//
//  Configuration.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

public enum Configuration {

  public struct CollectionView {

    internal weak var source: UICollectionView?
    internal var cells: [Hashes.Context: CellFactory]
    internal var supplementaries: [Hashes.Supplementary: SupplementaryFactory]

    internal typealias CellFactory = (UICollectionView, IndexPath, Any) -> Flare<UICollectionViewCell>
    internal typealias SupplementaryFactory = (UICollectionView, String, IndexPath, Any) -> Flare<UICollectionReusableView>
  }

  public struct TableView {

    internal weak var source: UITableView?
    internal var cells: [Hashes.Context: CellFactory]
    internal var supplementaries: [Hashes.Supplementary: SupplementaryFactory]

    internal typealias CellFactory = (UITableView, IndexPath, Any) -> Flare<UITableViewCell>
    internal typealias SupplementaryFactory = (UITableView, Any) -> Flare<UIView?>
  }

  public struct ViewController {

    internal weak var source: UIViewController?
    internal var segues: [Hashes.Segue: Transition.Configure]
    internal var provider: Converter<UIViewController>
    public internal(set) var converter: Converter<Transition>
  }

  public struct Window {

    internal weak var source: UIWindow?
    public internal(set) var converter: Converter<Transition>
  }
}
