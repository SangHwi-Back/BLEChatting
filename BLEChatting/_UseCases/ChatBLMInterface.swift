//
//  ChatBLMInterface.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import SwiftData
import CoreBluetooth

protocol ChatBLMInterface<Actions> {
    associatedtype Actions
    func reduce(_ action: Actions)
}

protocol ChatBLMResponderInterface: ChatBLMInterface {
    associatedtype Actions
    init(serviceID: CBUUID?)
}

protocol ChatBLMProviderInterface: ChatBLMInterface {
    associatedtype Actions
    init(serviceID: CBUUID)
    func sendMessage(characteristicID: CBUUID, message: String)
}

protocol ChatBLMListManageableInterface: ChatBLMInterface {
    associatedtype Actions
    var context: ModelContext { get }
    init(context: ModelContext)
}

protocol ChatBLMMesssageManageableInterface: ChatBLMInterface {
    associatedtype Actions
    var context: ModelContext { get }
    /// - Parameters:
    ///    - chatRoomID: CBService's CBUUID
    init(context: ModelContext, chatRoom: ChatRoom)
}
