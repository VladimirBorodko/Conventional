//
//  Reuseable.Builder.Registrator.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import UIKit

extension Reuseable.Builder.Registrator {

  public func byClass
    ( with reuseId: String = View.conventional.reuseIdentifier
    ) -> Configurator {
    return .init(registrator: self, source: .aClass(View.self), reuseId: reuseId)
  }

  public func fromNib
    ( name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    , with reuseId: String = View.conventional.reuseIdentifier
    ) -> Configurator {
    return .init(registrator: self, source: .assetNib(name, bundle), reuseId: reuseId)
  }

  public func fromNib
    ( data: Data
    , bundle: Bundle = View.conventional.bundle
    , with reuseId: String = View.conventional.reuseIdentifier
    ) -> Configurator {
    return .init(registrator: self, source: .dataNib(data, bundle), reuseId: reuseId)
  }

  public func inStoryboard
    ( with reuseId: String = View.conventional.reuseIdentifier
    ) -> Configurator {
    return .init(registrator: self, source: .storyboard, reuseId: reuseId)
  }
}
