//
//  CMTime+Ext.swift
//  IMusic
//
//  Created by wtildestar on 30/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
  func toDisplayString() -> String {
    guard !CMTimeGetSeconds(self).isNaN else { return "" }
    let totalSeconds = Int(CMTimeGetSeconds(self))
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60
    let timeFormatedString = String(format: "%02d:%02d", minutes, seconds)
    return timeFormatedString
  }
}
