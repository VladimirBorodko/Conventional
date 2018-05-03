//
//  Reuseable.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public struct Reuseable {

  internal let reuseId: String
  internal let configure: Configure

  internal typealias Configure = ( _ view: AnyObject, _ context: Any) throws -> Void

  internal enum Source {

    case aClass(AnyClass)
    case assetNib(String, Bundle)
    case dataNib(Data, Bundle)
    case storyboard
    case provide( (Any) throws -> UIView? )
  }

  public struct Builder<Built> {
    
    internal let built: Built
    internal var cells: [Brief] = []
    internal var supplementaries: [String: [Brief]] = [:]

    public struct Registrator<View: UIView> {

      internal let apply: Apply

      internal typealias Apply = (Brief) -> Builder

      public struct Configurator {

        internal let registrator: Registrator
        internal let source: Source
        internal let reuseId: String
      }
    }
  }

  struct Brief {

    internal let viewType: AnyClass
    internal let source: Source
    internal let reuseId: String
    internal let contextType: Any.Type
    internal let configure: Configure
  }
}
