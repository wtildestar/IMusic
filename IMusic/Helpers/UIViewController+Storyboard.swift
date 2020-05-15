//
//  UIViewController+Storyboard.swift
//  IMusic
//
//  Created by wtildestar on 14/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit

extension UIViewController {
  class func loadFromStoryboard<T: UIViewController>() -> T {
    let name = String(describing: T.self)
    let storyboard = UIStoryboard(name: name, bundle: nil)
    if let viewController = storyboard.instantiateInitialViewController() as? T {
      return viewController
    } else {
      fatalError("Error: No initial view controller in \(name) storyboard")
    }
  }
}
