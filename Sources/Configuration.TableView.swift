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
    ) throws -> UITableViewCell {
    do {
      try checkSameInstance(tableView, tv)
      let key = try makeKey(context)
      guard let configurator = cells[key] else { throw Errors.NotRegistered(key: key) }
      let cell = try objc_throws { tv.dequeueReusableCell(withIdentifier: configurator.reuseId, for: ip) }
      try configurator.configure(cell, context)
      return cell
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func header
    ( from tv: UITableView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UITableViewHeaderFooterView? {
    do {
      try checkSameInstance(tableView, tv)
      guard case let config?? = try? headers[makeKey(context)] else { return nil }
      let view = try objc_throws { tv.dequeueReusableHeaderFooterView(withIdentifier: config.reuseId) }
      try view.map { try config.configure($0, context) }
      return view
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  public func footer
    ( from tv: UITableView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UITableViewHeaderFooterView? {
    do {
      try checkSameInstance(tableView, tv)
      guard case let config?? = try? footers[makeKey(context)] else { return nil }
      let view = try objc_throws { tv.dequeueReusableHeaderFooterView(withIdentifier: config.reuseId) }
      try view.map { try config.configure($0, context) }
      return view
    } catch let e {
      assertionFailure("\(e)")
      throw e
    }
  }

  internal init
    ( _ builder: Reuseable.Builder<UITableView>
    ) throws {
    self.tableView = builder.built
    try builder.cells.registerUniqueReuseIds(builder.built.registerCell(brief:))
    cells = try builder.cells.uniqueModelContexts()
    try builder.supplementaries.values.reduce(into: [], +=).registerUniqueReuseIds(builder.built.registerView(brief:))
    headers = try builder.headers.uniqueModelContexts()
    footers = try builder.footers.uniqueModelContexts()
  }
}
