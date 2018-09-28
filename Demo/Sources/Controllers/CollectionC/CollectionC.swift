//
//  CollectionC.swift
//  Demo
//
//  Created by Vladimir Borodko on 09/05/2018.
//  Copyright © 2018 BorodCom. All rights reserved.
//

import UIKit
import Conventional

class StringCvcV: UICollectionViewCell {}
class IntCvcV: UICollectionViewCell {}

class CollectionC: UIViewController, UICollectionViewDataSource {

  @IBOutlet weak var collectionView: UICollectionView!

  var collectionConfiguration: Configuration.CollectionView!
  var cellModels: [CellModel] = [StringVM(text: "1"),StringVM(text: "2"), IntVM(number: 3)]

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionConfiguration = collectionView.conventional.configuration
      .cell(StringCvcV.self).byClass().noContext()
      .cell(IntCvcV.self).byClass().noContext()
      .build()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionConfiguration.cell(from: collectionView, at: indexPath, for: UIViewController.self)
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellModels.count
  }

}
