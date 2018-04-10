//
//  ReuseableBrief.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import Foundation

class ReuseableBrief {

  var reuseId: String!
  var source: Source!
  let viewType: AnyClass
  var contextType: Any.Type!
  var configure: Configure!

  init
    ( viewType: AnyClass
    ) {
    self.viewType = viewType
  }

  typealias Configure = ( _ view: Any, _ model: Any) throws -> Void

  struct Config {
    let reuseId: String
    let configure: Configure
  }

  enum Source {
    case aClass(AnyClass)
    case assetNib(String, Bundle)
    case dataNib(Data, Bundle)
    case storyboard
  }
}

extension Array where Element == ReuseableBrief {

  func registerUniqueReuseIds
    ( _ register: (ReuseableBrief) throws -> Void
    ) throws {
    _ = try self.reduce(into: [String:Void]()) { dict, brief in
      // If you need many model to one view relation try to register same view with different reuse identifiers
      guard dict[brief.reuseId] == nil else { throw NotUniqueReuseId(id: brief.reuseId) }
      try register(brief)
      dict[brief.reuseId] = ()
    }
  }

  func uniqueModelContexts() throws -> [String: ReuseableBrief.Config] {
    return try self.reduce(into: [:]) { dict, brief in
      let key = String(reflecting: brief.contextType)
      guard dict[key] == nil else { throw NotUniqueModel(type: brief.contextType) }
      dict[key] = .init(reuseId: brief.reuseId, configure: brief.configure)
    }
  }
}
