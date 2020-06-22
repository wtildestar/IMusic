//
//  Nib.swift
//  IMusic
//
//  Created by wtildestar on 20/06/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit

extension UIView {
  class func loadFromNib<T: UIView>() -> T {
    return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
  }
}
