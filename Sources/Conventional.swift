//
//  Conventional.swift
//  Conventional
//
//  Created by Vladimir on 07.07.17.
//
//

import UIKit

/// Protocol for altering default behaviour of composers via extension
public protocol Conventional {

  associatedtype Complying: AnyObject

  static var storyboardSegueIdentifier: String { get }
  static var embedSegueIdentifier: String { get }
  static var exclusiveStoryboardName: String { get }
  static var collectiveStoryboardName: String { get }
  static var collectiveStoryboardIdentifier: String { get }
  static var nibName: String { get }
  static var bundle: Bundle { get }
  static var reuseIdentifier: String { get }
  static var extractFromSegue: (UIStoryboardSegue) throws -> Complying { get }
  static var extractInstantiated: (UIViewController) throws -> Complying { get }
}

public extension Conventional {

  static var storyboardSegueIdentifier: String { return "To\(String(describing: Complying.self))" }
  static var embedSegueIdentifier: String { return "" }
  static var exclusiveStoryboardName: String { return String(describing: Complying.self) }
  static var collectiveStoryboardName: String { return "Main" }
  static var collectiveStoryboardIdentifier: String { return String(describing: Complying.self) }
  static var nibName: String { return String(describing: Complying.self) }
  static var bundle: Bundle { return Bundle(for: Complying.self) }
  static var reuseIdentifier: String { return String(describing: Complying.self) }
  static var extractInstantiated: (UIViewController) throws -> Complying {
    return { instantiated in
      if let complying = instantiated as? Complying { return complying }
      if let navigationController = instantiated as? UINavigationController
        , let complying = navigationController.viewControllers.first as? Complying
      { return complying }
      throw ExtractFailed(type: Complying.self)
    }
  }
  static var extractFromSegue: (UIStoryboardSegue) throws -> Complying {
    return { try extractInstantiated($0.destination) }
  }
}

public enum Convention<Complying: AnyObject>: Conventional { }
