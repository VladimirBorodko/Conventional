//
//  Compound.TableView.swift
//  Conventional
//
//  Created by Vladimir Borodko on 21/04/2018.
//

import UIKit

extension Compound.TableView {
  
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
