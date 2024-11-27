//
//  Environment+Extensions.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/27/24.
//

import SwiftUI

struct DarkmodeIndicator: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
  var isDark: Bool {
    get {
      self[DarkmodeIndicator.self]
    }
    set {
      self[DarkmodeIndicator.self] = newValue
    }
  }
}
