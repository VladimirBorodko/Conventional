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
    return Flare(context)
      .perform { _ in try checkSameInstance(source, tv) }
      .map(Hashes.Context.init(context:))
      .map(cells.value)
      .flatMap { $0(tv, ip, context) }
      .restore(UITableViewCell())
      .unwrap(file, line)
  }

  public func header
    ( from tv: UITableView
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UIView?
  {
    return Flare(context)
      .perform { _ in try checkSameInstance(source, tv) }
      .map(Hashes.Supplementary.header)
      .map(supplementaries.value)
      .flatMap { $0(tv, context) }
      .restore(nil)
      .unwrap(file, line)
  }

  public func footer
    ( from tv: UITableView
    , for context: Any
    , file: StaticString = #file
    , line: UInt = #line
    ) -> UIView?
  {
    return Flare(context)
      .perform { _ in try checkSameInstance(source, tv) }
      .map(Hashes.Supplementary.footer)
      .map(supplementaries.value)
      .flatMap { $0(tv, context) }
      .restore(nil)
      .unwrap(file, line)
  }

  internal init
    ( _ source: UITableView
    )
  {
    self.source = source
    self.cells = [:]
    self.supplementaries = [:]
  }
}
