//
//  Transition.Builder.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Transition.Builder {
  
  internal init
    ( _ built: Built )
  { self.built = built }

  public func register<Target: UIViewController>
    ( _: Target.Type
    ) -> Source<Target, UIViewController>
  { return register(Target.self, containedIn: UIViewController.self) }

  public func register<Target: UIViewController, Container: UIViewController>
    ( _: Target.Type
    , containedIn _: Container.Type
    , extract: @escaping Source<Target, Container>.Extract = Target.conventional.extract()
    ) -> Source<Target, Container>
  { return .init(builder: self, extract: extract) }
}

extension Transition.Builder where Built: ConventionComplying {

  public func mock<Context>
    ( for _: Context.Type
    , perform: @escaping (Built, Context) throws -> Void = Built.conventional.mock()
    ) -> Transition.Builder<Built>
  {
    var builder = self
    let brief = Transition.Brief.transit(Context.self) { context in
      return Flare(context)
        .map { try cast($0, Context.self) }
        .map { context in
          return Transition { built in
            return Flare(built)
              .map { try cast($0, Built.self) }
              .map { try perform($0, context) }
          }
        }
    }
    builder.briefs.append(brief)
    return builder
  }
}

extension Transition.Builder where Built: UIViewController {

  public func build
    ( file: StaticString = #file
    , line: UInt = #line
    ) -> Configuration.ViewController
  {
    return Flare(built)
      .map(Configuration.ViewController.init)
      .perform { configuration in
        try briefs
          .uniqueSegues()
          .map { configuration.segues = $0 }
          .escalate()
      }
      .perform { configuration in
        try briefs
          .uniqueProviders()
          .map { configuration.provider.converts = $0 }
          .escalate()
      }
      .perform { configuration in
        try briefs
          .uniqueTransitions()
          .map { configuration.converter.converts = $0 }
          .escalate()
      }
      .unwrap(file, line)
  }

  public func showInitial<Target: UIViewController & ConventionalConfigurable>
    ( _: Target.Type
    , storyboardName: String = Target.conventional.exclusiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    ) -> Transition.Builder<Built>
  {
    return register(Target.self)
      .instantiateInitial(storyboardName: storyboardName, in: bundle)
      .show()
      .configure(with: Target.configure(context:))
  }

  public func showInstantiated<Target: UIViewController & ConventionalConfigurable>
    ( _: Target.Type
    , storyboardName: String = Target.conventional.exclusiveStoryboardName
    , in bundle: Bundle = Target.conventional.bundle
    , storyboardId: String = Target.conventional.collectiveStoryboardIdentifier
    ) -> Transition.Builder<Built>
  {
    return register(Target.self)
      .instantiate(storyboardName: storyboardName, in: bundle, storyboardId: storyboardId)
      .show()
      .configure(with: Target.configure(context:))
  }

  public func embedd<Target: UIViewController>
    ( _: Target.Type
    , _ keyPath: ReferenceWritableKeyPath<Built, Target?>
    , segueId: String = Target.conventional.embeddSegueIdentifier
    ) -> Transition.Builder<Built>
  {
    return register(Target.self)
      .embeddSegue(segueId: segueId)
      .customConfigure { built, target, _ in built[keyPath: keyPath] = target }
  }

  public func segue<Target: UIViewController & ConventionalConfigurable>
    ( _: Target.Type
    , segueId: String = Target.conventional.storyboardSegueIdentifier
    ) -> Transition.Builder<Built>
  {
    return register(Target.self)
      .manualSegue(segueId: segueId)
      .configure(with: Target.configure(context:))
  }
}

extension Transition.Builder where Built: UIWindow {
  
  public func build
    ( file: StaticString = #file
    , line: UInt = #line
    ) -> Configuration.Window
  {
    return Flare(built)
      .map(Configuration.Window.init)
      .perform { configuration in
        try briefs
          .uniqueTransitions()
          .map { configuration.converter.converts = $0 }
          .escalate()
      }
      .unwrap(file, line)
  }
}
