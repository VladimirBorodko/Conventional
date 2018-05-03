//
//  Configuration.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

public enum Configuration {

  public struct Controller {

    internal weak var source: UIViewController?
    internal let segues: [Transition.Brief.Seguer.Key: (AnyObject, Any) -> Flare<Void>]
    internal let provides: [String: Flare<UIViewController>]
    public let converter: Converter<Transition>
  }

  public struct CollectionView {

    internal weak var source: UICollectionView?
    internal var cells: [String: CellFactory]
    internal var supplementaries: [String: [String: SupplementaryFactory]]

    internal typealias CellFactory = (UICollectionView, IndexPath, Any) -> Flare<UICollectionViewCell>
    internal typealias SupplementaryFactory = (UICollectionView, String, IndexPath, Any) -> Flare<UICollectionReusableView>
  }

  public struct TableView {

    internal weak var source: UITableView?
    internal var cells: [String: CellFactory]
    internal var headers: [String: SupplementaryFactory]
    internal var footers: [String: SupplementaryFactory]

    internal typealias CellFactory = (UITableView, IndexPath, Any) -> Flare<UITableViewCell>
    internal typealias SupplementaryFactory = (UITableView, Any) -> Flare<UIView?>
  }

  public struct ViewController {

    internal weak var source: UIViewController?
    internal let segues: [Transition.Brief.Seguer.Key: Transition.Configure]
    internal let provider: Converter<UIViewController>
    public let converter: Converter<Transition>
  }

  public struct Window {

    internal weak var source: UIWindow?
    public let converter: Converter<Transition>
  }
}
