//
//  ViewControllerCompound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public struct Transition {
  let perform : (UIViewController) throws -> Void
}

public class ViewControllerCompound {

  init() { }

  func perform(_ transition: Transition) { }
  func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
  var converter: AnyConverter<Transition> {
    return AnyConverter<Transition>.Builder.init().build()
  }
}
