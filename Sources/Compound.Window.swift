//
//  Compound.Window.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Compound.Window {

  internal init<W: UIWindow>
    ( _ builder: Transition.Builder<W>
    ) throws {
    source = builder.built
    controllers = try builder.controllers.uniqueTransitions()
  }
}
