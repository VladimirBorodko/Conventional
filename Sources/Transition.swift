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

  public struct Builder<Built> {

    internal let built: Built
    internal var mocks: [MockChapter] = []
    internal var segues: [SegueChapter] = []
    internal var controllers: [ControllerChapter] = []
    init(_ built: Built) {self.built = built}

    public struct Source<Target: UIViewController, Container> {
      internal let builder: Builder
      internal let extract: Extract

      typealias Extract = (UIViewController) throws -> Target

      public struct Transit {

      }

      public struct Configurator {

      }
    }
  }

  internal struct SegueChapter {

    internal let destinationType: AnyClass
    internal let segueId: String
    internal let configure: Configure

    internal struct Key: Hashable {

      internal let id: String
      internal let destination: String

      internal var hashValue: Int {return id.hashValue ^ destination.hashValue}

      internal static func ==
        (lhs: Key
        , rhs: Key
        ) -> Bool {
        return lhs.id == rhs.id && lhs.destination == rhs.destination
      }

      internal init
        ( _ chapter: SegueChapter
        ) {
        self.id = chapter.segueId
        self.destination = String(reflecting: chapter.destinationType)
      }

      internal init
        ( _ segue: UIStoryboardSegue
        ) {
        self.id = segue.identifier ?? ""
        self.destination = String(reflecting: type(of: segue.destination))
      }
    }
  }

  internal struct MockChapter {

    internal let contextType: Any.Type
  }

  internal struct ControllerChapter {
    
    internal let contextType: Any.Type
  }
}
