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

    let brief: ReuseableBrief
    let composer: ReuseableComposer

    public func byClass
      ( with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      brief.reuseId = reuseId
      brief.source = .aClass(View.self)
      return .init(brief: brief, composer: composer)
    }

    public func fromNib
      ( name: String = View.conventional.nibName
      , bundle: Bundle = View.conventional.bundle
      , with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      brief.reuseId = reuseId
      brief.source = .assetNib(name, bundle)
      return .init(brief: brief, composer: composer)
    }

    public func fromNib
      ( data: Data
      , bundle: Bundle = View.conventional.bundle
      , with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      brief.reuseId = reuseId
      brief.source = .dataNib(data, bundle)
      return .init(brief: brief, composer: composer)
    }

    public func inStoryboard
      ( with reuseId: String = View.conventional.reuseIdentifier
      ) -> Configurator<View> {
      brief.reuseId = reuseId
      brief.source = .storyboard
      return .init(brief: brief, composer: composer)
    }
  }

  public struct Configurator<View: UIView> {

    let brief: ReuseableBrief
    let composer: ReuseableComposer

    public func configure<Model, Owner: AnyObject>
      ( with _: Model.Type
      , owner: Owner
      , by closure: @escaping (Owner) -> (View, Model) -> Void
      ) -> ReuseableComposer {
      brief.contextType = Model.self
      brief.configure = { [weak owner] view, model in
        guard let owner = owner else { throw OwnerDeallocated<View>(configuratorType: Owner.self) }
        guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Model.self) }
        guard let model = model as? Model else { throw ModelTypeMismatch<View>(modelType: Model.self) }
        closure(owner)(view,model)
      }
      return composer
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (View, Model) -> Void
      ) -> ReuseableComposer {
      brief.contextType = Model.self
      brief.configure = { view, model in
        guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Model.self) }
        guard let model = model as? Model else { throw ModelTypeMismatch<View>(modelType: Model.self) }
        closure(view,model)
      }
      return composer
    }

    public func configure<Model>
      ( with _: Model.Type
      , by closure: @escaping (View) -> (Model) -> Void
      ) -> ReuseableComposer {
      brief.contextType = Model.self
      brief.configure = { view, model in
        guard let view = view as? View else { throw ViewTypeMismatch<View>(modelType: Model.self) }
        guard let model = model as? Model else { throw ModelTypeMismatch<View>(modelType: Model.self) }
        closure(view)(model)
      }
      return composer
    }
  }
}

public extension ReuseableComposer where T == UICollectionView {

  func cell<View: UICollectionViewCell>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    let brief = ReuseableBrief(viewType: View.self)
    cells.append(brief)
    return .init(brief: brief, composer: self)
  }

  func header<View: UICollectionReusableView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    let brief = ReuseableBrief(viewType: View.self)
    supplementaries[UICollectionElementKindSectionHeader] = headers + [brief]
    return .init(brief: brief, composer: self)
  }

  func footer<View: UICollectionReusableView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    let brief = ReuseableBrief(viewType: View.self)
    supplementaries[UICollectionElementKindSectionFooter] = footers + [brief]
    return .init(brief: brief, composer: self)
  }

  func supplementary<View: UICollectionReusableView>
    ( _: View.Type
    , of kind: String
    ) -> ReuseableComposer.Registrator<View> {
    let brief = ReuseableBrief(viewType: View.self)
    supplementaries[kind] = (supplementaries[kind] ?? []) + [brief]
    return .init(brief: brief, composer: self)
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
    let brief = ReuseableBrief(viewType: View.self)
    cells.append(brief)
    return .init(brief: brief, composer: self)
  }

  func header<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    let brief = ReuseableBrief(viewType: View.self)
    supplementaries[UICollectionElementKindSectionHeader] = headers + [brief]
    return .init(brief: brief, composer: self)
  }

  func footer<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> ReuseableComposer.Registrator<View> {
    let brief = ReuseableBrief(viewType: View.self)
    supplementaries[UICollectionElementKindSectionFooter] = footers + [brief]
    return .init(brief: brief, composer: self)
  }

  func build() -> TableViewCompound {
    do {
      return try .init(self)
    } catch let e {
      fatalError("\(e)")
    }
  }
}
