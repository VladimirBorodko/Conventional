//
//  ReuseableComposer.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public final class ReuseableComposer<T> {

  let view: T
  var cells: [ReuseableBrief] = []
  var supplementaries: [String: [ReuseableBrief]] = [:]

  var headers: [ReuseableBrief] {
    return supplementaries[UICollectionElementKindSectionHeader] ?? []
  }
  var footers: [ReuseableBrief] {
    return supplementaries[UICollectionElementKindSectionFooter] ?? []
  }

  init
    ( _ view: T
    ) {
    self.view = view
  }

  typealias Factory = (ReuseableBrief) -> ReuseableComposer
  
  public struct Registrator<View: UIView> {

    let factory: Factory

    public func byClass
      ( with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      return .init(reuseId: reuseId, source: .aClass(View.self), factory: factory)
    }

    public func fromNib
      ( name: String = View.conventional.nibName
      , bundle: Bundle = View.conventional.bundle
      , with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      return .init(reuseId: reuseId, source: .assetNib(name, bundle), factory: factory)
    }

    public func fromNib
      ( data: Data
      , bundle: Bundle = View.conventional.bundle
      , with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      return .init(reuseId: reuseId, source: .dataNib(data, bundle), factory: factory)
    }

    public func inStoryboard
      ( with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      return .init(reuseId: reuseId, source: .storyboard, factory: factory)
    }
  }

  public struct Configurator<View: UIView> {

    let reuseId: String
    let source: ReuseableBrief.Source
    let factory: Factory

    public func configure<Model, Owner: AnyObject>
      ( with _: Model.Type
      , owner: Owner
      , by closure: @escaping (Owner) -> (View, Model) -> Void
      ) -> ReuseableComposer {
      let brief = ReuseableBrief(reuseId: reuseId, source: source, viewType: View.self, modelType: Model.self) { [weak owner] view, model in
        guard let owner = owner else { throw OwnerDeallocated<View>(configuratorType: Owner.self) }
        guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Model.self) }
        guard let model = model as? Model else { throw ModelTypeMismatch<View>(modelType: Model.self) }
        closure(owner)(view,model)
      }
      return factory(brief)
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (View, Model) -> Void
      ) -> ReuseableComposer {
      let brief = ReuseableBrief(reuseId: reuseId, source: source, viewType: View.self, modelType: Model.self) { view, model in
        guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Model.self) }
        guard let model = model as? Model else { throw ModelTypeMismatch<View>(modelType: Model.self) }
        closure(view,model)
      }
      return factory(brief)
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (View) -> (Model) -> Void
      ) -> ReuseableComposer {
      let brief = ReuseableBrief(reuseId: reuseId, source: source, viewType: View.self, modelType: Model.self) { view, model in
        guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Model.self) }
        guard let model = model as? Model else { throw ModelTypeMismatch<View>(modelType: Model.self) }
        closure(view)(model)
      }
      return factory(brief)
    }
  }
}

public extension ReuseableComposer where T == UICollectionView {

  func cell<View: UICollectionViewCell>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    return .init { brief in
      self.cells.append(brief)
      return self
    }
  }

  func header<View: UICollectionReusableView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    return .init { brief in
      self.supplementaries[UICollectionElementKindSectionHeader] = self.headers + [brief]
      return self
    }
  }

  func footer<View: UICollectionReusableView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    return .init { brief in
      self.supplementaries[UICollectionElementKindSectionFooter] = self.footers + [brief]
      return self
    }
  }

  func supplementary<View: UICollectionReusableView>
    ( _: View.Type
    , of kind: String
    ) -> ReuseableComposer.Registrator<View> {
    return .init { brief in
      self.supplementaries[kind] = (self.supplementaries[kind] ?? []) + [brief]
      return self
    }
  }

  func build() -> CollectionViewCompound {
    do {
      return try .init(self)
    } catch let e {
      fatalError("\(e)")
    }
  }
}

public extension ReuseableComposer where T == UITableView {

  func cell<View: UITableViewCell>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    return .init { brief in
      self.cells.append(brief)
      return self
    }
  }

  func header<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    return .init { brief in
      self.supplementaries[UICollectionElementKindSectionHeader] = self.headers + [brief]
      return self
    }
  }

  func footer<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    return .init { brief in
      self.supplementaries[UICollectionElementKindSectionFooter] = self.footers + [brief]
      return self
    }
  }

  func build() -> TableViewCompound {
    do {
      return try .init(self)
    } catch let e {
      fatalError("\(e)")
    }
  }
}
