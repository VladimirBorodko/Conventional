//
//  TransitionComposer.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import UIKit

public class TransitionComposer<Source> {

  public func registerMock<Model>
    ( for _: Model.Type
    ) -> TransitionComposer {
    return self
  }

  public func register<Controller: UIViewController>
    ( _: Controller.Type
    ) -> Destination<Controller> {
    return .init()
  }


  init() { }

  public class Destination<Controller: UIViewController> {

    func storyboardSegue<Sender: AnyObject>
      ( by _: Sender.Type
      , segueId: String = Controller.conventional.storyboardSegueIdentifier
      , extract: (UIStoryboardSegue) throws -> Controller = Controller.conventional.extractFromSegue
      ) -> SegueConfig<Controller, Sender> {
      return .init()
    }

    func embedSegue
      ( segueId: String = Controller.conventional.embedSegueIdentifier
      , extract: (UIStoryboardSegue) throws -> Controller = Controller.conventional.extractFromSegue
      ) -> SegueConfig<Controller, Source> {
      return .init()
    }

    func manualSegue
      ( id: String = Controller.conventional.storyboardSegueIdentifier
      , extract: (UIStoryboardSegue) throws -> Controller = Controller.conventional.extractFromSegue
      ) -> Configurator<Controller> {
      return .init()
    }

    func instantiateInitial
      ( from storyboardName: String = Controller.conventional.exclusiveStoryboardName
      , in bundle: Bundle = Controller.conventional.bundle
      , extract: (UIViewController) throws -> Controller = Controller.conventional.extractInstantiated
      ) -> Transit<Controller> {
      return .init()
    }


    func instantiate
      ( from storyboardName: String = Controller.conventional.collectiveStoryboardName
      , in bundle: Bundle = Controller.conventional.bundle
      , by id: String = Controller.conventional.collectiveStoryboardIdentifier
      , extract: (UIViewController) throws -> Controller = Controller.conventional.extractInstantiated
      ) -> Transit<Controller> {
      return .init()
    }

    func create
      ( with factory: () throws -> Controller
      ) -> Transit<Controller> {
      return .init()
    }
  }

  public class SegueConfig<Controller,Sender> {

    public func configure
      ( by closure: @escaping (Source) -> (Controller, Sender) -> Void
      ) -> TransitionComposer {
      return .init()
    }

    public func configure
      ( by closure: @escaping (Source, Controller, Sender) -> Void
      ) -> TransitionComposer {
      return .init()
    }

    public func configure<Router>
      ( router: Router
      , by closure: @escaping (Router) -> (Source, Controller, Sender) -> Void
      ) -> TransitionComposer {
      return .init()
    }
  }

  public class Transit<Controller: UIViewController> {

    func push() -> Configurator<Controller> {
      return .init()
    }

    func show() -> Configurator<Controller> {
      return .init()
    }

    func present() -> Configurator<Controller> {
      return .init()
    }

    func custom() -> Configurator<Controller> {
      return .init()
    }

    func setAsRoot() -> Configurator<Controller> {
      return .init()
    }
  }

  public class Configurator<Controller: UIViewController> {

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (Source) -> (Controller, Model) -> Void
      ) -> TransitionComposer {
      return .init()
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (Source, Controller, Model) -> Void
      ) -> TransitionComposer {
      return .init()
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (Controller) -> (Model) -> Void
      ) -> TransitionComposer {
      return .init()
    }

    public func configure<Model, Router>
      ( with _: Model.Type
      , router: Router
      , by closure: @escaping (Router) -> (Source, Controller, Model) -> Void
      ) -> TransitionComposer {
      return .init()
    }
  }
}
