//
//  TableViewCompound.swift
//  Conventional
//
//  Created by Vladimir Borodko on 31/03/2018.
//

import UIKit

public final class TableViewCompound {

  let cells: [String: ReuseableBrief.Config]
  let headers: [String: ReuseableBrief.Config]
  let footers: [String: ReuseableBrief.Config]
  weak var tableView: UITableView?

  init
    ( _ builder: ReuseableComposer<UITableView>
    ) throws {
    self.tableView = builder.view
    try builder.cells.registerUniqueReuseIds(builder.view.registerCell(brief:))
    cells = try builder.cells.uniqueModelContexts()
    try builder.supplementaries.values.reduce(into: [], +=).registerUniqueReuseIds(builder.view.registerView(brief:))
    headers = try builder.headers.uniqueModelContexts()
    footers = try builder.footers.uniqueModelContexts()
  }

  func cell
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

private extension UITableView {

  func registerCell
    ( brief: ReuseableBrief
    ) throws {
    switch brief.source! {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forCellReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forCellReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forCellReuseIdentifier: brief.reuseId) }
    case .storyboard:
      break
    }
  }

  func registerView
    ( brief: ReuseableBrief
    ) throws {
    switch brief.source! {
    case let .aClass(aClass):
      try objc_throws { self.register(aClass, forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case let .assetNib(name,bundle):
      try objc_throws { self.register(UINib(nibName: name, bundle: bundle), forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case let .dataNib(data, bundle):
      try objc_throws { self.register(UINib(data: data, bundle: bundle), forHeaderFooterViewReuseIdentifier: brief.reuseId) }
    case .storyboard:
      break
    }
  }
}
