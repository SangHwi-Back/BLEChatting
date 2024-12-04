//
//  ChatBLMInterface.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

protocol ChatBLMInterface<Actions> {
    associatedtype Actions
    associatedtype ConcreteBLMType: ChatBLMInterface
    var concrete: ConcreteBLMType { get }
    func reduce(_ action: Actions)
}

protocol ChatBLMResponderInterface: ChatBLMInterface {
    init(serviceID: CBUUID?)
}

protocol ChatBLMProviderInterface: ChatBLMInterface {
    init(serviceID: CBUUID)
    func sendMessage(characteristicID: CBUUID, message: String)
}
