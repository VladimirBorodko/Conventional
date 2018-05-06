//
//  Reuseable.Builder+UITableView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 23/04/2018.
//

import UIKit

extension Reuseable.Builder where Built == UITableView {

  public func cell<View: UITableViewCell>
    ( _: View.Type
    ) -> Registrator<View>
  {
    return .init { brief in
      var builder = self
      builder.cells.append(brief)
      return builder
    }
  }

  public func header<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View>
  {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [brief]
      return builder
    }
  }

  public func footer<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View>
  {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [brief]
      return builder
    }
  }

  public func noHeader<Context>
    ( for _: Context.Type
    ) -> Reuseable.Builder<Built>
  {
    let source = Reuseable.Source.provide { _ in nil }
    var builder = self
    builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [.init(contextType: Context.self, source: source)]
    return builder
  }

  public func noFooter<Context>
    ( for _: Context.Type
    ) -> Reuseable.Builder<Built>
  {
    let source = Reuseable.Source.provide { _ in nil }
    var builder = self
    builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [.init(contextType: Context.self, source: source)]
    return builder
  }

  public func makeHeader<Context>
    ( for _: Context.Type
    , factory: @escaping (Context) -> UIView?
    ) -> Reuseable.Builder<Built>
  {
    let source = Reuseable.Source.provide { context in
      let context = try cast(context, Context.self)
      return factory(context)
    }
    var builder = self
    builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [.init(contextType: Context.self, source: source)]
    return builder
  }

  public func makeFooter<Context>
    ( for _: Context.Type
    , factory: @escaping (Context) -> UIView?
    ) -> Reuseable.Builder<Built>
  {
    let source = Reuseable.Source.provide { context in
      let context = try cast(context, Context.self)
      return factory(context)
    }
    var builder = self
    builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [.init(contextType: Context.self, source: source)]
    return builder
  }

  public func cellFromNib<View: UITableViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built>
  {
    return cell(View.self)
      .fromNib(reuseId: reuseId, name: name, bundle: bundle)
      .configure(with: View.configure(context:))
  }

  public func cellByClass<View: UITableViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return cell(View.self)
      .byClass(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func cellInStoryboard<View: UITableViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return cell(View.self)
      .inStoryboard(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func headerFromNib<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built>
  {
    return header(View.self)
      .fromNib(reuseId: reuseId, name: name, bundle: bundle)
      .configure(with: View.configure(context:))
  }

  public func headerByClass<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return header(View.self)
      .byClass(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func headerInStoryboard<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return header(View.self)
      .inStoryboard(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func footerFromNib<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built>
  {
    return footer(View.self)
      .fromNib(reuseId: reuseId, name: name, bundle: bundle)
      .configure(with: View.configure(context:))
  }

  public func footerByClass<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return footer(View.self)
      .byClass(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func footerInStoryboard<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return footer(View.self)
      .inStoryboard(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func build
    ( file: StaticString = #file
    , line: UInt = #line
    ) -> Configuration.TableView
  {
    return Flare(built)
      .perform { tv in try cells
        .registerUniqueReuseIds(tv.registerCell(brief:))
        .escalate()
      }.perform { tv in try supplementaries
        .values
        .reduce(into: [], +=)
        .registerUniqueReuseIds(tv.registerView(brief:))
        .escalate()
      }.map(Configuration.TableView.init)
      .perform { configuaration in
        try cells
          .uniqueCellContexts(dequeueTableCell)
          .map { configuaration.cells = $0 }
          .escalate()
      }.perform { configuaration in
        try supplementaries
          .uniqueSupplementaryContexts(dequeueTableSupplementary)
          .map { configuaration.supplementaries = $0 }
          .escalate()
      }.unwrap(file, line)
  }
}
