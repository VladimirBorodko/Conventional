//
//  Errors.swift
//  Conventional
//
//  Created by Vladimir Borodko on 03/04/2018.
//

import UIKit

public struct OwnerDeallocated<View>: Error { let configuratorType: AnyObject.Type }
public struct ViewTypeMismatch<View>: Error { let modelType: Any.Type }
public struct ModelTypeMismatch<View>: Error { let modelType: Any.Type }
public struct NotUniqueReuseId: Error { let id: String }
public struct NotUniqueModel: Error { let type: Any.Type }
public struct NotRegisteredContext: Error { let type: Any.Type }
public struct WrongViewInstance: Error { let view: AnyObject }
public struct OpaqueWrapperUnwrapFailed: Error { let type: Any.Type }
public struct ExtractFailed: Error { let type: Any.Type }
public struct SegueNotRecognized: Error {let segue: UIStoryboardSegue}

public struct Temp: Error {
  static var error: Temp { return Temp() }
}

