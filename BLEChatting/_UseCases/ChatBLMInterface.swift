//
//  ChatBLMInterface.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

protocol ChatBLMInterface {}

protocol ChatBLMResponderInterface: ChatBLMInterface {
    init(_ centralManager: CBCentralManager)
    func getMessagFromPeripheral(peripheralID: String, message: String)
    func getDataFromPeripheral(peripheralID: String, data: Data)
    func getDictFromPeripheral(peripheralID: String, dict: Dictionary<String, Any>)
}

protocol ChatBLMProviderInterface: ChatBLMInterface {
    init(_ peripheralManager: CBPeripheralManager)
    func sendMessage(characteristicID: String, message: String, chatRoomID: String)
    func sendData(characteristicID: String, data: Data, chatRoomID: String)
}
