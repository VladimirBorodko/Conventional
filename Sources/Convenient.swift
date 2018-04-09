//
//  Convenient.swift
//  Conventional
//
//  Created by Vladimir Borodko on 02/07/2017.
//
//

import UIKit

/// Namespace for conventional functions
public struct Convenient<Base>: ConvenientCompatible {
  public let base: Base
  public init(_ base: Base) { self.base = base }
}

public protocol ConvenientCompatible {
  associatedtype ComplyingType
  static var convenient: Convenient<ComplyingType>.Type { get set }
  var convenient: Convenient<ComplyingType> { get set }

}

public extension ConvenientCompatible {
  static var convenient: Convenient<Self>.Type {
    get { return Convenient<Self>.self }
    set { }
  }
  var convenient: Convenient<Self> {
    get { return Convenient(self) }
    set { }
  }
}

extension UIView: ConvenientCompatible { }
extension UIViewController: ConvenientCompatible { }

public extension Convenient where Base: UIViewController {
  var composer: TransitionComposer<Base> { return .init() }
}

public extension Convenient where Base: UIWindow {
  var composer: TransitionComposer<Base> { return .init() }
}

public extension Convenient where Base: UICollectionView {
  var composer: ReuseableComposer<Base> { return .init(base) }
}

public extension Convenient where Base: UITableView {
  var composer: ReuseableComposer<Base> { return .init(base) }
}
