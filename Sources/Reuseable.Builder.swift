//
//  Reuseable.Builder.swift
//  Conventional
//
//  Created by Vladimir Borodko on 19/04/2018.
//

import Foundation

extension Reuseable.Builder {

  internal var headers: [Reuseable.Brief] {
    return supplementaries[UICollectionElementKindSectionHeader] ?? []
  }
  
  internal var footers: [Reuseable.Brief] {
    return supplementaries[UICollectionElementKindSectionFooter] ?? []
  }

  internal init
    ( _ built: Built
    ) {
    self.built = built
  }
}

extension Reuseable.Builder where Built == UICollectionView {

  public func cell<View: UICollectionViewCell>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.cells.append(brief)
      return builder
    }
  }

  public func header<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [brief]
      return builder
    }
  }

  public func footer<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [brief]
      return builder
    }
  }

  public func supplementary<View: UICollectionReusableView>
    ( _: View.Type
    , kind: String
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[kind] = (builder.supplementaries[kind] ?? []) + [brief]
      return builder
    }
  }

  public func cellFromNib<View: UICollectionViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built> {
    return cell(View.self).fromNib(reuseId: reuseId, name: name, bundle: bundle).configure(with: View.configure(context:))
  }

  public func cellByClass<View: UICollectionViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return cell(View.self).byClass(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func cellInStoryboard<View: UICollectionViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return cell(View.self).inStoryboard(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func headerFromNib<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built> {
    return header(View.self).fromNib(reuseId: reuseId, name: name, bundle: bundle).configure(with: View.configure(context:))
  }

  public func headerByClass<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return header(View.self).byClass(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func headerInStoryboard<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return header(View.self).inStoryboard(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func footerFromNib<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built> {
    return footer(View.self).fromNib(reuseId: reuseId, name: name, bundle: bundle).configure(with: View.configure(context:))
  }

  public func footerByClass<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return footer(View.self).byClass(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func footerInStoryboard<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return footer(View.self).inStoryboard(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func supplementaryFromNib<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , kind: String
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built> {
    return supplementary(View.self, kind: kind).fromNib(reuseId: reuseId, name: name, bundle: bundle).configure(with: View.configure(context:))
  }

  public func supplementaryByClass<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , kind: String
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return supplementary(View.self, kind: kind).byClass(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func supplementaryInStoryboard<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , kind: String
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return supplementary(View.self, kind: kind).inStoryboard(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func build() throws -> Compound.CollectionView {
    do {
      return try .init(self)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}

extension Reuseable.Builder where Built == UITableView {

  public func cell<View: UITableViewCell>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.cells.append(brief)
      return builder
    }
  }

  public func header<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [brief]
      return builder
    }
  }

  public func footer<View: UITableViewHeaderFooterView>
    ( _: View.Type
    ) -> Registrator<View> {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [brief]
      return builder
    }
  }

  public func cellFromNib<View: UITableViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built> {
    return cell(View.self).fromNib(reuseId: reuseId, name: name, bundle: bundle).configure(with: View.configure(context:))
  }

  public func cellByClass<View: UITableViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return cell(View.self).byClass(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func cellInStoryboard<View: UITableViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return cell(View.self).inStoryboard(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func headerFromNib<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built> {
    return header(View.self).fromNib(reuseId: reuseId, name: name, bundle: bundle).configure(with: View.configure(context:))
  }

  public func headerByClass<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return header(View.self).byClass(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func headerInStoryboard<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return header(View.self).inStoryboard(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func footerFromNib<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built> {
    return footer(View.self).fromNib(reuseId: reuseId, name: name, bundle: bundle).configure(with: View.configure(context:))
  }

  public func footerByClass<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return footer(View.self).byClass(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func footerInStoryboard<View: UITableViewHeaderFooterView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built> {
    return footer(View.self).inStoryboard(reuseId: reuseId).configure(with: View.configure(context:))
  }

  public func build() throws -> Compound.TableView {
    do {
      return try .init(self)
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }
}
