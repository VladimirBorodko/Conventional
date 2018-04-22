//
//  ViewController.swift
//  ConventionalDemo
//
//  Created by Vladimir Borodko on 29/03/2018.
//  Copyright © 2018 BorodCom. All rights reserved.
//

import UIKit
import Conventional

protocol CellModel { }

struct StringVM: CellModel {
  let text: String
}

struct IntVM: CellModel {
  let number: Int
}

class StringCellV: UITableViewCell {
  func configure(stringVM: StringVM) {
    textLabel?.text = stringVM.text
  }
}

class IntCellV: UITableViewCell {
  func configure(intVM: IntVM) {
    textLabel?.text = String(intVM.number)
  }
}

class WelcomeC: UIViewController, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!

  var tableConfiguration: Configuration.TableView!
  var cellModels: [CellModel] = [StringVM(text: "1"),StringVM(text: "2"), IntVM(number: 3)]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableConfiguration = try? tableView.conventional.configuration
      .cell(StringCellV.self).byClass().configure(with: StringCellV.configure(stringVM:))
      .cell(IntCellV.self).byClass().configure(with: IntCellV.configure(intVM:))
      .build()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return try! tableConfiguration.cell(from: tableView, at: indexPath, for: cellModels[indexPath.row])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellModels.count
  }
}
