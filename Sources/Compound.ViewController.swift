//
//  Compound.ViewController.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Compound.ViewController {

  internal init<VC: UIViewController>
    ( _ builder: Transition.Builder<VC>
    ) throws {
    source = builder.built
    segues = try builder.segues.uniqueSegues()
    controllers = try builder.controllers.uniqueTransitions()
  }
}
