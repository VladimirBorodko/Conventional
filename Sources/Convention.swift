//
//  Convention.swift
//  Conventional
//
//  Created by Vladimir on 07.07.17.
//
//

import UIKit

public protocol Convention {

  associatedtype Complying: AnyObject

  static var storyboardSegueIdentifier: String { get }
  static var embeddSegueIdentifier: String { get }
  static var exclusiveStoryboardName: String { get }
  static var collectiveStoryboardName: String { get }
  static var collectiveStoryboardIdentifier: String { get }
  static var nibName: String { get }
  static var bundle: Bundle { get }
  static var reuseIdentifier: String { get }
  static var transitionDuration: TimeInterval { get }
  static var transitionOptions: UIViewAnimationOptions { get }
  static func extract<Container: UIViewController>() -> (Container) throws -> Complying
  static func mock<Context>() -> (Complying, Context) throws -> Void
}

extension Convention {

  public static var storyboardSegueIdentifier: String { return "To\(String(describing: Complying.self))" }
  public static var embeddSegueIdentifier: String { return "" }
  public static var exclusiveStoryboardName: String { return String(describing: Complying.self) }
  public static var collectiveStoryboardName: String { return "Main" }
  public static var collectiveStoryboardIdentifier: String { return String(describing: Complying.self) }
  public static var nibName: String { return String(describing: Complying.self) }
  public static var bundle: Bundle { return Bundle(for: Complying.self) }
  public static var reuseIdentifier: String { return String(describing: Complying.self) }
  public static var transitionDuration: TimeInterval { return 0.3 }
  public static var transitionOptions: UIViewAnimationOptions { return [.transitionCrossDissolve] }
  public static func extract<Container: UIViewController>() -> (Container) throws -> Complying {
    return { instantiated in
      if let complying = instantiated as? Complying { return complying }
      if let navigationController = instantiated as? UINavigationController
        , let complying = navigationController.viewControllers.first as? Complying {
        return complying
      }
      throw ExtractFailed(type: Complying.self)
    }
  }
  public static func mock<Context>() -> (Complying, Context) throws -> Void {
    return { _, _ in }
  }
}
