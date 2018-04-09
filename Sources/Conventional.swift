//
//  Conventional.swift
//  Conventional
//
//  Created by Vladimir Borodko on 02/07/2017.
//
//

import UIKit

public struct Conventional<Complying: AnyObject>: Convention {
  public let complying: Complying
  public init
    ( _ complying: Complying
    ) {
    self.complying = complying
  }
}

public protocol ConventionComplying {
  associatedtype Complying: AnyObject
  static var conventional: Conventional<Complying>.Type { get set }
  var conventional: Conventional<Complying> { get set }
}

public extension ConventionComplying where Self: AnyObject {
  static var conventional: Conventional<Self>.Type {
    get { return Conventional<Self>.self }
    set { }
  }
  var conventional: Conventional<Self> {
    get { return Conventional(self) }
    set { }
  }
}

extension UIView: ConventionComplying { }
extension UIViewController: ConventionComplying { }

public extension Conventional where Complying: UIViewController {
  var composer: TransitionComposer<Complying> { return .init() }
}

public extension Conventional where Complying: UIWindow {
  var composer: TransitionComposer<Complying> { return .init() }
}

public extension Conventional where Complying: UICollectionView {
  var composer: ReuseableComposer<Complying> { return .init(complying) }
}

public extension Conventional where Complying: UITableView {
  var composer: ReuseableComposer<Complying> { return .init(complying) }
}
