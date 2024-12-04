//
//  CBUUID+Extensions.swift
//  BLEChatting
//
//  Created by 백상휘 on 12/4/24.
//

import Foundation
import CoreBluetooth

extension CBUUID {
    static let TEST = CBUUID(string: "1ff6cd45-184b-4398-82bc-810cd5955439")
    static let CHARTEST = CBUUID(string: "c5ef7944-9a6b-4cdc-b737-07cc7ee86bd5")
}
// Core Bluetooth 에서 Peripheral 역할을 할 때 각 패킷마다 CBUUID 는 어떻게 생성하는게 일반적인지 검색해줘.
