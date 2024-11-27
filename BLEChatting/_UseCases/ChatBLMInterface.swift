//
//  ChatBLMInterface.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

protocol ChatBLMInterface2 {}
protocol ChatBLMInterface {
    associatedtype Actions
    associatedtype ConcreteBLMType: ChatBLMInterface
    var concrete: ConcreteBLMType { get }
    func reduce(_ action: Actions)
}

protocol ChatBLMResponderInterface: ChatBLMInterface2 {
    init(_ centralManager: CBCentralManager)
    func getMessagFromPeripheral(peripheralID: String, message: String)
    func getDataFromPeripheral(peripheralID: String, data: Data)
    func getDictFromPeripheral(peripheralID: String, dict: Dictionary<String, Any>)
}

protocol ChatBLMProviderInterface: ChatBLMInterface2 {
    init(_ peripheralManager: CBPeripheralManager)
    func sendMessage(characteristicID: String, message: String, chatRoomID: String)
    func sendData(characteristicID: String, data: Data, chatRoomID: String)
}
