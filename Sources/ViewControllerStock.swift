//
//  ViewControllerStock.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public struct Transition {
  internal let perform : (AnyObject) throws -> Void
}

public class ViewControllerStock {

  public let converter: AnyConverter<Transition> = {
    return AnyConverter<Transition>.Builder.init().build()
  }()
  internal weak var source: UIViewController?
  internal let segues: [SegueBrief.Key: SegueBrief.Perform] = [:]

  internal init() { }

  public func perform
    ( _ transition: Transition
    ) throws {
    do {
      guard let source = source else {
        throw Temp.error
      }
      try transition.perform(source)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func prepare
    ( for segue: UIStoryboardSegue
    , sender: Any?
    ) throws {
    do {
      guard let sender = sender else {
        throw SegueNotRecognized(segue: segue)
      }
      if let perform = sender as? TransitionBrief.Perform {
        try perform(segue)
        return
      }
      guard let perform = segues[.init(segue)] else {
        throw SegueNotRecognized(segue: segue)
      }
      try perform(segue, sender)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func provide
    ( for context: Any
    ) throws -> UIViewController {
    do {
      throw Temp.error
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
  
}
