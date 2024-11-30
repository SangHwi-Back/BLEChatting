//
//  ChatProviderUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

class ChatProviderUseCase: ChatBLMProviderInterface {
    let peripheralManager: CBPeripheralManager
    
    required init(_ peripheralManager: CBPeripheralManager) {
        self.peripheralManager = peripheralManager
    }
    
    func sendMessage(characteristicID: String, message: String, chatRoomID: String) {
        
    }
    
    func sendData(characteristicID: String, data: Data, chatRoomID: String) {
        
    }
}
