# Conventional

![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20tvOS-333333.svg)

###### Conventional is a library that helps you to:

* unify storyboard segues and custom transitions
* separate storyboard related code from view controllers
* export transition logic without exposing view controllers
* reduce boilerplate by using reflection in the way that is conventional for your project
* have opportunity to deviate from convention where you need to
* keep reuseable cell factories code expressive
* combine cell registration and dequeueing code
* detect internal inconsistency earlier in debug time
* have debug information on what's wrong
* catch objc / cpp exceptions in swift


## Usage

###### Configure UITableView or UICollectionView:

``` swift
override func viewDidLoad() {
  super.viewDidLoad()
  tableConfiguration = try? tableView.conventional.configuration
    .cell(StringCellV.self).byClass().configure(with: StringCellV.configure(stringVM:))
    .cell(IntCellV.self).inStoryboard().configure(with: IntCellV.configure(intVM:))
    .cellFromNib(ConventionalCell1V.self)
    .cellFromNib(ConventionalCell2V.self)
    .build()
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  return try! tableConfiguration!.cell(from: tableView, at: indexPath, for: cellModels[indexPath.row])
}
```

###### Configure UIWindow:

``` swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  let window = UIWindow(frame: UIScreen.main.bounds)
  self.window = window

  windowConfiguration = try? window.conventional.configuration
    .register(WelcomeC.self).instantiateInitial().changeRoot().noContext()
    .build()

  _ = try? windowConfiguration?.transit(WelcomeC.self)
  return true
}
```

###### Configure UIViewController:

``` swift
override func viewDidLoad() {
  super.viewDidLoad()
  configuration = try? self.conventional.configuration
    .embedd(SubController.self, \.subController)
    .showInitial(SeguedC.self)
    .build()
  viewModel = ViewModel(converter: configuration.converter, transit: {[weak self] in _ = try? self?.configuration.perform($0)})
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  try? configuration?.prepare(for: segue, sender: sender)
}
```

## Requirements

* Xcode 9.0
* Swift 4.1

## Dependencies

Conventional depends only on UIKit
