//
//  Reuseable.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public enum Reuseable {

  internal typealias Configure = ( _ view: Any, _ model: Any) throws -> Void

  internal enum Source {
    case aClass(AnyClass)
    case assetNib(String, Bundle)
    case dataNib(Data, Bundle)
    case storyboard
  }

  public struct Brief {
    internal let reuseId: String
    internal let configure: Configure
  }

  public struct Builder<T> {
    internal let view: T
    internal var cells: [Chapter] = []
    internal var supplementaries: [String: [Chapter]] = [:]

    internal var headers: [Chapter] {
      return supplementaries[UICollectionElementKindSectionHeader] ?? []
    }
    internal var footers: [Chapter] {
      return supplementaries[UICollectionElementKindSectionFooter] ?? []
    }

    internal init
      ( _ view: T
      ) {
      self.view = view
    }

    public struct Registrator<View: UIView> {
      internal let add: Add

      internal typealias Add = (Chapter) -> Builder

      public struct Configurator {
        internal let registrator: Registrator
        internal let source: Source
        internal let reuseId: String
      }
    }
  }

  struct Chapter {
    internal let viewType: AnyClass
    internal let source: Source
    internal let reuseId: String
    internal let contextType: Any.Type
    internal let configure: Configure
  }
}
