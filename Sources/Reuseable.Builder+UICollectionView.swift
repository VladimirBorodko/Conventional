//
//  Reuseable.Builder+UICollectionView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 23/04/2018.
//

import Foundation

extension Reuseable.Builder where Built == UICollectionView {

  public func cell<View: UICollectionViewCell>
    ( _: View.Type
    ) -> Registrator<View>
  {
    return .init { brief in
      var builder = self
      builder.cells.append(brief)
      return builder
    }
  }

  public func header<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View>
  {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionHeader] = builder.headers + [brief]
      return builder
    }
  }

  public func footer<View: UICollectionReusableView>
    ( _: View.Type
    ) -> Registrator<View>
  {
    return .init { brief in
      var builder = self
      builder.supplementaries[UICollectionElementKindSectionFooter] = builder.footers + [brief]
      return builder
    }
  }

  public func supplementary<View: UICollectionReusableView>
    ( _: View.Type
    , kind: String
    ) -> Registrator<View>
  {
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
    ) -> Reuseable.Builder<Built>
  {
    return cell(View.self)
      .fromNib(reuseId: reuseId, name: name, bundle: bundle)
      .configure(with: View.configure(context:))
  }

  public func cellByClass<View: UICollectionViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return cell(View.self)
      .byClass(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func cellInStoryboard<View: UICollectionViewCell & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return cell(View.self)
      .inStoryboard(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func headerFromNib<View: UICollectionReusableView & ConventionalConfigurable>
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

  public func headerByClass<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return header(View.self)
      .byClass(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func headerInStoryboard<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return header(View.self)
      .inStoryboard(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func footerFromNib<View: UICollectionReusableView & ConventionalConfigurable>
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

  public func footerByClass<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return footer(View.self)
      .byClass(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func footerInStoryboard<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return footer(View.self)
      .inStoryboard(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func supplementaryFromNib<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , kind: String
    , reuseId: String = View.conventional.reuseIdentifier
    , name: String = View.conventional.nibName
    , bundle: Bundle = View.conventional.bundle
    ) -> Reuseable.Builder<Built>
  {
    return supplementary(View.self, kind: kind)
      .fromNib(reuseId: reuseId, name: name, bundle: bundle)
      .configure(with: View.configure(context:))
  }

  public func supplementaryByClass<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , kind: String
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return supplementary(View.self, kind: kind)
      .byClass(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func supplementaryInStoryboard<View: UICollectionReusableView & ConventionalConfigurable>
    ( _: View.Type
    , kind: String
    , reuseId: String = View.conventional.reuseIdentifier
    ) -> Reuseable.Builder<Built>
  {
    return supplementary(View.self, kind: kind)
      .inStoryboard(reuseId: reuseId)
      .configure(with: View.configure(context:))
  }

  public func build
    ( file: StaticString = #file
    , line: UInt = #line
    ) -> Configuration.CollectionView
  {
    return Flare(built)
      .perform { cv in try cells
        .registerUniqueReuseIds(cv.registerCell(brief:))
        .escalate()
      }.perform { cv in
        try supplementaries
          .reduce(Flare<Void>(())) { (flare, pair) in
            let (kind, briefs) = pair
            return flare.flatMap { _ in
              briefs.registerUniqueReuseIds(kind: kind) { brief in
                try cv.registerView(kind: kind, brief: brief)
              }
            }
          }
          .escalate()
      }.map(Configuration.CollectionView.init)
      .perform { configuaration in
        try cells
          .uniqueCellContexts(dequeueCollectionCell)
          .map { configuaration.cells = $0 }
          .escalate()
      }.perform { configuaration in
        try supplementaries
          .uniqueSupplementaryContexts(dequeueCollectionSupplementary)
          .map { configuaration.supplementaries = $0 }
          .escalate()
      }.unwrap(file, line)
  }
}
