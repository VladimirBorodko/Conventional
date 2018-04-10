//
//  TransitionComposer.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import UIKit

public class TransitionComposer<Source> {

  let source: Source
  var segues: [SegueBrief] = []
  var transitions: [TransitionBrief] = []
  var mocks: [Any.Type] = []

  public func registerMock<Model>
    ( for _: Model.Type
    ) -> TransitionComposer {
    mocks.append(Model.self)
    return self
  }

  public func register<Controller: UIViewController>
    ( _: Controller.Type
    ) -> Destination<Controller> {
    return .init(composer: self)
  }

  init
    ( _ source: Source
    ) {
    self.source = source
  }

  public struct Destination<Controller: UIViewController> {

    let composer: TransitionComposer

    func storyboardSegue<Sender: AnyObject>
      ( by _: Sender.Type
      , segueId: String = Controller.conventional.storyboardSegueIdentifier
      , extract: @escaping (UIStoryboardSegue) throws -> Controller = Controller.conventional.extractFromSegue
      ) -> SegueConfig<Controller, Sender> {
      let brief = SegueBrief()
      brief.segueId = segueId
      brief.senderType = Sender.self
      brief.extract = {try extract($0)}
      composer.segues.append(brief)
      return .init(brief: brief, composer: composer)
    }

    func embedSegue
      ( segueId: String = Controller.conventional.embedSegueIdentifier
      , extract: @escaping (UIStoryboardSegue) throws -> Controller = Controller.conventional.extractFromSegue
      ) -> SegueConfig<Controller, Source> {
      let brief = SegueBrief()
      brief.segueId = segueId
      brief.senderType = Source.self
      brief.extract = {try extract($0)}
      composer.segues.append(brief)
      return .init(brief: brief, composer: composer)
    }

    func manualSegue
      ( id: String = Controller.conventional.storyboardSegueIdentifier
      , extract: (UIStoryboardSegue) throws -> Controller = Controller.conventional.extractFromSegue
      ) -> Configurator<Controller> {
      let brief = TransitionBrief()
      composer.transitions.append(brief)
      return .init(brief: brief, composer: composer)
    }

    func instantiateInitial
      ( from storyboardName: String = Controller.conventional.exclusiveStoryboardName
      , in bundle: Bundle = Controller.conventional.bundle
      , extract: (UIViewController) throws -> Controller = Controller.conventional.extractInstantiated
      ) -> Transit<Controller> {
      let brief = TransitionBrief()
      composer.transitions.append(brief)
      return .init(brief: brief, composer: composer)
    }


    func instantiate
      ( from storyboardName: String = Controller.conventional.collectiveStoryboardName
      , in bundle: Bundle = Controller.conventional.bundle
      , by id: String = Controller.conventional.collectiveStoryboardIdentifier
      , extract: (UIViewController) throws -> Controller = Controller.conventional.extractInstantiated
      ) -> Transit<Controller> {
      let brief = TransitionBrief()
      composer.transitions.append(brief)
      return .init(brief: brief, composer: composer)
    }

    func create
      ( with factory: () throws -> Controller
      ) -> Transit<Controller> {
      let brief = TransitionBrief()
      composer.transitions.append(brief)
      return .init(brief: brief, composer: composer)
    }
  }

  public struct SegueConfig<Controller,Sender> {

    let brief: SegueBrief
    let composer: TransitionComposer

    public func configure
      ( by closure: @escaping (Source) -> (Controller, Sender) -> Void
      ) -> TransitionComposer {
      return composer
    }

    public func configure
      ( by closure: @escaping (Source, Controller, Sender) -> Void
      ) -> TransitionComposer {
      return composer
    }

    public func configure<Router>
      ( router: Router
      , by closure: @escaping (Router) -> (Source, Controller, Sender) -> Void
      ) -> TransitionComposer {
      return composer
    }
  }

  public struct Transit<Controller: UIViewController> {

    let brief: TransitionBrief
    let composer: TransitionComposer

  }

  public struct Configurator<Controller: UIViewController> {

    let brief: TransitionBrief
    let composer: TransitionComposer

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (Source) -> (Controller, Model) -> Void
      ) -> TransitionComposer {
      return composer
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (Source, Controller, Model) -> Void
      ) -> TransitionComposer {
      return composer
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (Controller) -> (Model) -> Void
      ) -> TransitionComposer {
      return composer
    }

    public func configure<Model, Router>
      ( with _: Model.Type
      , router: Router
      , by closure: @escaping (Router) -> (Source, Controller, Model) -> Void
      ) -> TransitionComposer {
      return composer
    }
  }
}

public extension TransitionComposer.Transit where Source: UIViewController {
  func push() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }

  func show() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }

  func present() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }

  func custom() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }
}

public extension TransitionComposer.Transit where Source: UIWindow {
  func setAsRoot() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }
}

public extension TransitionComposer.Transit where Source: UINavigationController {
  func setAsRoot() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }
}
