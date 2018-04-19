//
//  TransitionBrief.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import UIKit

class TransitionBrief {
  internal var contextType: Any.Type!
  internal var configure: Configure!
  internal var transit: Transit!
  internal var extract: Extract!

  internal enum TransitType {
    case storyboard(String, (UIViewController)throws->Void)
  }

  internal typealias Transit = () throws -> Void
  internal typealias Provide = () throws -> UIViewController
  internal typealias Configure = (_ source: AnyObject,  _ context: Any) throws -> Void
  internal typealias Extract = (_ destination: UIViewController) throws -> UIViewController
  internal typealias Perform = (UIStoryboardSegue) throws -> Void
}
