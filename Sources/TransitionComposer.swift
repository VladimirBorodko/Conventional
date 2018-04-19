//
//  TransitionComposer.swift
//  Conventional
//
//  Created by Vladimir Borodko on 09/04/2018.
//

import UIKit

public class TransitionComposer<Source> {

  internal let source: Source
  internal var segues: [SegueBrief] = []
  internal var transitions: [TransitionBrief] = []
  internal var mocks: [Any.Type] = []

  public func mock<Model>
    ( for _: Model.Type
    ) -> TransitionComposer {
    mocks.append(Model.self)
    return self
  }

  public func register<Target: UIViewController>
    ( _: Target.Type
    ) -> Destination<Target> {
    return .init(composer: self)
  }

  public func register<Target: UIViewController, Container: UIViewController>
    ( _: Target.Type
    , containedIn _: Container.Type
    , extract: (Container)->Target?
    ) -> Destination<Target> {
    return .init(composer: self)
  }


  internal init
    ( _ source: Source
    ) {
    self.source = source
  }

  public struct Destination<Controller: UIViewController> {

    internal let composer: TransitionComposer


    public func instantiateInitial
      ( from storyboardName: String = Controller.conventional.exclusiveStoryboardName
      , in bundle: Bundle = Controller.conventional.bundle
      , extract: @escaping (UIViewController) throws -> Controller = Controller.conventional.extract
      ) -> Transit<Controller> {
      let brief = TransitionBrief()
      composer.transitions.append(brief)
      let provide: TransitionBrief.Provide = {
        let controller = try objc_throws {
          UIStoryboard(name: storyboardName, bundle: bundle).instantiateInitialViewController()
        }
        guard let unwrapped = controller else {throw Temp.error}
        return try extract(unwrapped)
      }
      return .init(provide: provide, brief: brief, composer: composer)
    }


    public func instantiate
      ( from storyboardName: String = Controller.conventional.collectiveStoryboardName
      , in bundle: Bundle = Controller.conventional.bundle
      , by id: String = Controller.conventional.collectiveStoryboardIdentifier
      , extract: @escaping (UIViewController) throws -> Controller = Controller.conventional.extract
      ) -> Transit<Controller> {
      let brief = TransitionBrief()
      composer.transitions.append(brief)
      let provide: TransitionBrief.Provide = {
        let controller = try objc_throws {
          UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: id)
        }
        return try extract(controller)
      }
      return .init(provide: provide, brief: brief, composer: composer)
    }

    public func create
      ( with factory: @escaping () throws -> Controller
      ) -> Transit<Controller> {
      let brief = TransitionBrief()
      composer.transitions.append(brief)
      return .init(provide: factory, brief: brief, composer: composer)
    }
  }

  public struct SegueConfig<Controller> {

    internal let brief: SegueBrief
    internal let composer: TransitionComposer

    public func configure
      ( by closure: @escaping (Source) -> (Controller, _ sender: Any) -> Void
      ) -> TransitionComposer {
      return composer
    }

    public func configure
      ( by closure: @escaping (Source, Controller, _ sender: Any) -> Void
      ) -> TransitionComposer {
      return composer
    }

    public func configure<Router>
      ( router: Router
      , by closure: @escaping (Router) -> (Source, Controller, _ sender: Any) -> Void
      ) -> TransitionComposer {
      return composer
    }
    public func configure<Router>
      ( router: Router
      , by closure: @escaping (Router) -> (Controller) -> Void
      ) -> TransitionComposer {
      return composer
    }
  }

  public struct Transit<Controller: UIViewController> {

    internal let provide: TransitionBrief.Provide
    internal let brief: TransitionBrief
    internal let composer: TransitionComposer

  }

  public struct Configurator<Controller: UIViewController> {

    internal let brief: TransitionBrief
    internal let composer: TransitionComposer

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

extension TransitionComposer.Destination where Source: UIViewController {

  public func storyboardSegue
    ( with id: String = Controller.conventional.storyboardSegueIdentifier
    ) -> TransitionComposer.SegueConfig<Controller> {
    let brief = SegueBrief()
    brief.segueId = id
    brief.destinayionType = Controller.self
    brief.extract = { segue in
      guard let destination = segue.destination as? Controller else {
        throw ExtractFailed(type: Controller.self)
      }
      return destination
    }
    composer.segues.append(brief)
    return .init(brief: brief, composer: composer)
  }

  public func storyboardSegue<Container: UIViewController>
    ( with id: String = Controller.conventional.storyboardSegueIdentifier
    , container type: Container.Type
    , extract: @escaping (Container) throws -> Controller = Controller.conventional.extract
    ) -> TransitionComposer.SegueConfig<Controller> {
    let brief = SegueBrief()
    brief.segueId = id
    brief.destinayionType = Container.self
    brief.extract = { segue in
      guard let destination = segue.destination as? Container else {
        throw ExtractFailed(type: Container.self)
      }
      return try extract(destination)
    }
    composer.segues.append(brief)
    return .init(brief: brief, composer: composer)
  }

  public func manualSegue
    ( id: String = Controller.conventional.storyboardSegueIdentifier
    ) -> TransitionComposer.Configurator<Controller> {
    let brief = TransitionBrief()
    composer.transitions.append(brief)
    return .init(brief: brief, composer: composer)
  }

  public func manualSegue<Container: UIViewController>
    ( id: String = Controller.conventional.storyboardSegueIdentifier
    , container _: Container.Type
    , extract: @escaping (Container) throws -> Controller = Controller.conventional.extract
    ) -> TransitionComposer.Configurator<Controller> {
    let brief = TransitionBrief()
    composer.transitions.append(brief)
    return .init(brief: brief, composer: composer)
  }
}

extension TransitionComposer.Transit where Source: UIViewController {

  public func push() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }

  public func show() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }

  public func present() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }

  public func custom() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }
}

extension TransitionComposer.Transit where Source: UIWindow {
  public func setAsRoot() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }
}

extension TransitionComposer.Transit where Source: UINavigationController {
  public func setAsRoot() -> TransitionComposer.Configurator<Controller> {
    return .init(brief: brief, composer: composer)
  }
}
