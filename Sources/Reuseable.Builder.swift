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
    ( _ built: Built )
  { self.built = built }
}
