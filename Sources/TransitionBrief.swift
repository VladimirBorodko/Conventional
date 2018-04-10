//
//  TransitionBrief.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import UIKit

class TransitionBrief {
  var contextType: Any.Type!
  var configure: Configure!
  var provide: Provide!
  var perform: Perform!

  typealias Perform = (_ source: AnyObject, _ destination: UIViewController) throws -> Void
  typealias Provide = () throws -> UIViewController
  typealias Configure = (_ source: AnyObject,  _ context: Any) throws -> Void
}
