//
//  TableViewStock.swift
//  Conventional
//
//  Created by Vladimir Borodko on 31/03/2018.
//

import UIKit

public final class TableViewStock {

  internal let cells: [String: Reuseable.Brief]
  internal let headers: [String: Reuseable.Brief]
  internal let footers: [String: Reuseable.Brief]
  internal weak var tableView: UITableView?

  internal init
    ( _ builder: Reuseable.Builder<UITableView>
    ) throws {
    self.tableView = builder.view
    try builder.cells.registerUniqueReuseIds(builder.view.registerCell(chapter:))
    cells = try builder.cells.uniqueModelContexts()
    try builder.supplementaries.values.reduce(into: [], +=).registerUniqueReuseIds(builder.view.registerView(chapter:))
    headers = try builder.headers.uniqueModelContexts()
    footers = try builder.footers.uniqueModelContexts()
  }

  public func cell
    ( from tv: UITableView
    , at ip: IndexPath
    , for context: Any
    ) -> UITableViewCell {
    do {
      let contextType = type(of: context)
      guard tv === tableView else { throw WrongViewInstance(view: tv) }
      guard let configurator = cells[String(reflecting: contextType)] else { throw NotRegisteredContext(type: contextType) }
      let cell = try objc_throws { tv.dequeueReusableCell(withIdentifier: configurator.reuseId, for: ip) }
      try configurator.configure(cell, context)
      return cell
    } catch let e {
      preconditionFailure("\(e)")
    }
  }

  public func header
    ( from tv: UITableView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UITableViewHeaderFooterView? {
    do {
      let contextType = type(of: context)
      guard tv === tableView else {throw WrongViewInstance(view: tv)}
      guard let config = headers[String(reflecting: contextType)] else { return nil }
      let view = try objc_throws { tv.dequeueReusableHeaderFooterView(withIdentifier: config.reuseId) }
      try view.map { try config.configure($0, context) }
      return view
    } catch let e {
      preconditionFailure("\(e)")
    }
  }

  public func footer
    ( from tv: UITableView
    , at ip: IndexPath
    , for context: Any
    ) throws -> UITableViewHeaderFooterView? {
    do {
      let contextType = type(of: context)
      guard tv === tableView else {throw WrongViewInstance(view: tv)}
      guard let config = footers[String(reflecting: contextType)] else { return nil }
      let view = try objc_throws { tv.dequeueReusableHeaderFooterView(withIdentifier: config.reuseId) }
      try view.map { try config.configure($0, context) }
      return view
    } catch let e {
      preconditionFailure("\(e)")
    }
  }
}

