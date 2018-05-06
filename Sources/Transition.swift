//
//  Transition.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

public struct Transition {

  internal let perform : (AnyObject) -> Flare<Void>

  internal typealias Configure = ( _ view: AnyObject, _ context: Any) -> Flare<Void>
  internal typealias Provide = ( _ context: Any) -> Flare<UIViewController>
  internal typealias Transit = ( _ context: Any) -> Flare<Transition>

  public struct Builder<Built: AnyObject> {

    internal let built: Built
    internal var briefs: [Brief] = []

    public struct Source<Target: UIViewController, Container: AnyObject> {

      internal let builder: Builder
      internal let extract: Extract

      public typealias Extract = (Container) throws -> Target

      public struct Transit {

        internal let source: Source
        internal let make: Make

        public typealias Make = () throws -> Container
      }

      public struct Configurator {
        
        internal let built: Built
        internal let apply: Apply

        internal typealias Apply = (_ contextType: Any.Type, _ configure: @escaping Configure) -> Builder
      }
    }
  }

  internal enum Brief {

    case segue(String, AnyClass, Configure)
    case transit(Any.Type, Transit)
    case provide(Any.Type, Provide)
  }

  internal struct Sender {

    internal let send: Send
    internal typealias Send = (UIStoryboardSegue) -> Flare<Void>
  }
}

extension Transition {

  internal static func empty
    () -> Transition
  { return .init { _ in return Flare(())} }
}
