//
//  ViewControllerCompound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public struct Transition {
  let perform : (AnyObject) throws -> Void
}

public class ViewControllerCompound {

  public let converter: AnyConverter<Transition> = {
    return AnyConverter<Transition>.Builder.init().build()
  }()
  weak var source: UIViewController?
  let segues: [SegueBrief.Key: SegueBrief.Configure] = [:]

  init() { }

  func perform
    ( _ transition: Transition
    ) {
    do {
      guard let source = source else {
        throw Temp.error
      }
      try transition.perform(source)
    } catch let e {
      preconditionFailure("\(e)")
    }
  }

  func prepare
    ( for segue: UIStoryboardSegue
    , sender: Any?
    ) {
    do {
      guard let sender = sender else {
        throw SegueNotRecognized(segue: segue)
      }
      if let send = sender as? (UIStoryboardSegue)throws->Void {
        try send(segue)
        return
      }
      guard let configure = segues[.init(segue, sender)] else {
        throw SegueNotRecognized(segue: segue)
      }
      try configure(segue, sender)
    } catch let e {
      preconditionFailure("\(e)")
    }
  }
  
}
