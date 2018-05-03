//
//  Configuration.TableView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Configuration.TableView {
  
  public func cell
    ( from tv: UITableView
    , at ip: IndexPath
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UITableViewCell
  {
    return Flare(context, file: file, line : line)
      .perform { _ in try checkSameInstance(source, tv) }
      .map(makeKey)
      .map { try cells[$0].unwrap(Errors.NotRegistered(key: $0)) }
      .flatMap { $0(tv, ip, context) }
      .unwrap()
//    do {
//      try checkSameInstance(source, tv)
//      let key = try makeKey(context)
//      guard let configurator = cells[key] else { throw Errors.NotRegistered(key: key) }
//      let cell = try objc_throws { tv.dequeueReusableCell(withIdentifier: configurator.reuseId, for: ip) }
//      try configurator.configure(cell, context)
//      return cell
//    } catch let e {
//      assertionFailure("\(e)")
//      throw e
//    }
  }

  public func header
    ( from tv: UITableView
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UIView?
  {
    return Flare(context, file: file, line : line)
      .perform { _ in try checkSameInstance(source, tv) }
      .map(makeKey)
      .map { try headers[$0].unwrap(Errors.NotRegistered(key: $0)) }
      .flatMap { $0(tv, context) }
      .restore(nil)
      .unwrap()
//    do {
//      try checkSameInstance(source, tv)
//      guard case let config?? = try? headers[makeKey(context)] else { return nil }
//      let view = try objc_throws { tv.dequeueReusableHeaderFooterView(withIdentifier: config.reuseId) }
//      try view.map { try config.configure($0, context) }
//      return view
//    } catch let e {
//      assertionFailure("\(e)")
//      throw e
//    }
  }

  public func footer
    ( from tv: UITableView
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UIView?
  {
    return Flare(context, file: file, line : line)
      .perform { _ in try checkSameInstance(source, tv) }
      .map(makeKey)
      .map { try footers[$0].unwrap(Errors.NotRegistered(key: $0)) }
      .flatMap { $0(tv, context) }
      .restore(nil)
      .unwrap()
//    do {
//      try checkSameInstance(source, tv)
//      guard case let config?? = try? footers[makeKey(context)] else { return nil }
//      let view = try objc_throws { tv.dequeueReusableHeaderFooterView(withIdentifier: config.reuseId) }
//      try view.map { try config.configure($0, context) }
//      return view
//    } catch let e {
//      assertionFailure("\(e)")
//      throw e
//    }
  }

  internal init
    ( _ source: UITableView
    )
  {
//    try builder.cells.registerUniqueReuseIds(builder.built.registerCell(brief:))
//    var cells = try builder.cells.uniqueModelContexts()
//    try builder.supplementaries.values.reduce(into: [], +=).registerUniqueReuseIds(builder.built.registerView(brief:))
//    var headers = try builder.headers.uniqueModelContexts()
//    var footers = try builder.footers.uniqueModelContexts()

    self.source = source
    self.cells = [:]
    self.headers = [:]
    self.footers = [:]
  }
}
