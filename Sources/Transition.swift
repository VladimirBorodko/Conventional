//
//  Transition.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

public struct Transition {

  internal let perform : (AnyObject) throws -> Void

  internal typealias Configure = ( _ view: AnyObject, _ context: Any) throws -> Void
  internal typealias Provide = ( _ context: Any) throws -> UIViewController

  public struct Builder<Built: AnyObject> {

    internal let built: Built
    internal var seguers: [Brief.Seguer] = []
    internal var transiters: [Brief.Transiter] = []
    internal var providers: [Brief.Provider] = []

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

    internal struct Seguer {

      internal let destinationType: AnyClass
      internal let segueId: String
      internal let configure: Configure

      internal struct Key {

        internal let id: String
        internal let destination: AnyClass
      }

      internal struct Sender {

        internal let send: Send
        internal typealias Send = (UIStoryboardSegue) throws -> Void
      }
    }

    internal struct Transiter {

      internal let contextType: Any.Type
      internal let configure: Configure
    }

    internal struct Provider {

      internal let contextType: Any.Type
      internal let provide: Provide
    }
  }
}
