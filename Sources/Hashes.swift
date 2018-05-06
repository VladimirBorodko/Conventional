//
//  Hashes.swift
//  Conventional
//
//  Created by Vladimir Borodko on 06/05/2018.
//

import Foundation

internal enum Hashes {
  
  internal struct Segue {
    
    internal let id: String
    internal let destination: AnyClass
  }

  internal struct Supplementary {

    internal let kind: String
    internal let context: Any.Type
    internal let contextId: ObjectIdentifier
  }

  internal struct Context {

    internal let context: Any.Type
    internal let contextId: ObjectIdentifier
  }
}
