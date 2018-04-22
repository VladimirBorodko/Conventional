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

extension ConventionComplying where Self: AnyObject {

  public static var conventional: Conventional<Self>.Type {
    get { return Conventional<Self>.self }
    set { }
  }

  public var conventional: Conventional<Self> {
    get { return Conventional(self) }
    set { }
  }
}

extension UIView: ConventionComplying { }
extension UIViewController: ConventionComplying { }

extension Conventional where Complying: UIViewController {

  public var compound: Transition.Builder<Complying> { return .init(complying) }
}

extension Conventional where Complying: UIWindow {

  public var compound: Transition.Builder<Complying> { return .init(complying) }
}

extension Conventional where Complying: UICollectionView {

  public var compound: Reuseable.Builder<UICollectionView> { return .init(complying) }
}

extension Conventional where Complying: UITableView {
  
  public var compound: Reuseable.Builder<Complying> { return .init(complying) }
}

public protocol ConventionalConfigurable {
  associatedtype Context
  func configure(context: Context)
}
